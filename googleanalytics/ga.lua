--- Main module for the Google Analytics implementation for the Defold game
-- engine.
--
-- @usage
-- local ga = require "googleanalytics.ga"
-- function init(self)
-- 	ga.get_default_tracker().screenview("my_cool_screen")
-- end
-- function update(self, dt)
-- 	ga.update()
-- end
-- function on_input(self, action_id, action)
-- 	if gui.pick_node(node, action.x, action.y) and action.pressed then
-- 		go.get_default_tracker().event("category", "action"))
-- 	end
-- end


local tracker = require "googleanalytics.tracker"
local queue = require "googleanalytics.internal.queue"

local M = {
	dispatch_period = tonumber(sys.get_config("googleanalytics.dispatch_period", 30 * 60)),
}

local default_tracker = nil

--- Get the default tracker
-- @return Tracker instance
---@return GoogleAnalyticsTracker
function M.get_default_tracker(id)
	if not default_tracker then
		local tracking_id = id or sys.get_config("googleanalytics.tracking_id")
		assert(tracking_id, "You must set tracking_id in section [googleanalytics] in game.project before using this module")
		default_tracker = tracker.create(tracking_id)
	end
	return default_tracker
end

--- Dispatch hits to Google Analytics
function M.dispatch()
	queue.dispatch()
end

--- Update the Google Analytics module.
-- This will check if automatic dispatch of hits are enabled and if so, if it is
-- time to dispatch stored hits.
function M.update()
	-- manual dispatch only?
	if M.dispatch_period <= 0 then
		return
	end

	if not queue.last_dispatch_time or (socket.gettime() >= (queue.last_dispatch_time + M.dispatch_period)) then
		M.dispatch()
	end
end

return M