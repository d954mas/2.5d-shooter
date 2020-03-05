local GA = require "googleanalytics.ga"
local GA_QUEUE = require "googleanalytics.internal.queue"
local LOG = require "libs.log"
local CONTEXTS = require "libs_project.contexts_manager"
local COMMON = require "libs.common"
local EVENTS = require "libs_project.events"
local JSON = require "libs.json"

local TAG = "GOOGLE ANALYTICS"


local M = {}

function M.init(tracking_id, uuid)
	assert(tracking_id)
	assert(uuid)
	assert(not M.tracker, "already inited")
	GA_QUEUE.log = function(s, ...)
		if (s == "") then
			return
		end
		if select("#", ...) > 0 then
			LOG.i(s:format(...), TAG, 2)
		else
			LOG.i(s, TAG, 2)
		end
	end
	M.tracker = GA.get_default_tracker(tracking_id, uuid)

	local handle = crash.load_previous()
	if handle then
		M.tracker.exception(crash.get_extra_data(handle), true)
		crash.release(handle)
	end

	M.subscription = COMMON.EVENT_BUS:subscribe(EVENTS.ERROR):subscribe(function (data)
		--do not send same message
		self.exception_prev_time = self.exception_prev_time or 0
		if self.exception_prev ~= data.message or (os.time() - self.exception_prev_time) > 60 * 1 then
			GA.exception(JSON.encode(data, false));
			self.exception_prev = data.message
			self.exception_prev_time = os.time()
		end
	end)
end

function M.flush()
	if (CONTEXTS:exist(CONTEXTS.NAMES.MAIN)) then
		local ctx = CONTEXTS:set_context_top_main()
		GA_QUEUE.dispatch()
		ctx:remove()
	end
end

function M.is_inited()
	return M.tracker and true or false
end

function M.update(dt)
	if M.tracker then
		GA.update()
	end
end

function M.event(category, action, label, value)
	if M.tracker then
		M.tracker.event(category, action, label, value)
	else
		GA_QUEUE.log("no tracker")
	end
end

function M.exception(description, is_fatal)
	if M.tracker then
		M.tracker.exception(description, is_fatal)
		M.tracker.event("exception", description)
	end
end

function M.timing(category, variable, time, label)
	if (M.tracker) then
		M.tracker.timing(category, variable, time, label)
	end
end

function M.screenview(name)
	if (M.tracker) then
		M.tracker.screenview(name)
	end
end

return M