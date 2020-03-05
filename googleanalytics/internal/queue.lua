--- Queue of Google Analytics hit tracking
-- The queue provides functionality to add data to the queue and to send the
-- data to the Google Analytics servers.
-- The queue is persisted to disk. It is loaded from disk when this module
-- is initialised and written periodically.
-- The queue will hold a configurable amount of hit data. If the limit is
-- reached the oldest data will be thrown away.

local file = require "googleanalytics.internal.file"
local json_encode = require "libs.json"
local user_agent = require "googleanalytics.internal.user_agent"

local M = {
	last_dispatch_time = nil,
	last_save_time = nil,
	minimum_save_period = tonumber(sys.get_config("googleanalytics.queue_save_period", 5 * 60)),
}


-- payload rules, https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
local MAX_HITS_PER_PAYLOAD = 20				-- A maximum of 20 hits can be specified per request.
local MAX_HIT_SIZE = 8 * 1024				-- No single hit payload can be greater than 8K bytes.
local MAX_TOTAL_PAYLOAD_SIZE = 16 * 1024	-- The total size of all hit payloads cannot be greater than 16K bytes.

local QUEUE_FILENAME = "__ga_queue"

local q = {}

local queue_data = file.load(QUEUE_FILENAME)
if queue_data then
	local decoded_queue, err = pcall(json.decode, json)
	if not err then
		q = decoded_queue
	end
end


local function sort()
	table.sort(q, function(a, b)
		return a.time < b.time
	end)
end


function M.log(...)
	-- no-op
end

if sys.get_config("googleanalytics.verbose") == "1" then
	M.log = function(s, ...)
		if select("#", ...) > 0 then
			print(s:format(...))
		else
			print(s)
		end
	end
end

--- Add tracking parameters to queue
-- @param params
function M.add(params)
	assert(params, "You must provide params")
	if #params <= MAX_HIT_SIZE then
		table.insert(q, { time = socket.gettime(), params = params })
	end

	if #q > 0 and (not M.last_save_time or (socket.gettime() >= (M.last_save_time + M.minimum_save_period))) then
		local ok, err = pcall(function()
			assert(file.save(QUEUE_FILENAME, json_encode.encode(q)))
		end)
		if not ok then
			M.log("ERR: Something went wrong while saving Google Analytics data", err)
			M.dispatch()
			q = {}
			return
		end
		M.last_save_time = socket.gettime()
	end
end

--- Dispatch all stored hits to Google Analytics
function M.dispatch()
	M.last_dispatch_time = socket.gettime()
	if #q == 0 then
		M.log("Nothing to send")
		return
	end

	local hits_to_retry = {}
	while #q > 0 do

		local hits_in_flight = {}
		local payload = {}
		local payload_size = 0
		for _=1,math.min(MAX_HITS_PER_PAYLOAD, #q) do
			local hit = q[1]
			local queue_time = math.floor((socket.gettime() - hit.time) * 1000)
			local qt = "&qt=" .. tostring(queue_time)
			local hit_size = #hit.params + #qt
			if payload_size + hit_size <= MAX_TOTAL_PAYLOAD_SIZE then
				local data = table.remove(q, 1)
				table.insert(hits_in_flight, data)
				payload[#payload + 1] = data.params .. qt
				payload_size = payload_size + hit_size
			end
		end

		if #payload > 0 then
			local post_data = table.concat(payload, "\n")
			local headers = { ["User-Agent"] = user_agent.get() }
			M.log("Sending %d hit(s) to Google Analytics", #hits_in_flight)
			http.request("https://www.google-analytics.com/batch", "POST", function(self, id, response)
				if response.status < 200 or response.status >= 300 then
					M.log("ERR: Problem when sending hits to Google Analytics. Code: ", response.status)
					for i=1,#hits_in_flight do
						hits_to_retry[#hits_to_retry + 1] = hits_in_flight[i]
					end
				end
			end, headers, post_data)
		end
	end

	-- re-add any hits that we failed to send due to http errors
	if #hits_to_retry > 0 then
		for i=1,#hits_to_retry do
			q[#q + 1] = hits_to_retry[i]
		end
		sort()
	end
end



return M