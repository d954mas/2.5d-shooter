local COMMON = require "libs.common"
local RENDERCAM = require "rendercam.rendercam"


--LOCK CURSOR LIKE IN SHOOTER.
local M = {}
M.cursor_movement = vmath.vector3(0)
function M.register_listeners()
	window.set_listener(function (self,event,sss)
		M.prev_state = not M.locked
		if event == window.WINDOW_EVENT_FOCUS_LOST then
			M.unlock_cursor()
		elseif event == window.WINDOW_EVENT_FOCUS_GAINED then
			if M.prev_state then
				M.lock_cursor()
				M.prev_state = nil
			end
		end
	end)
end

function M.unregister_listener()
	window.set_listener(function () end)
end

function M.lock_cursor()
	M.locked = true
	defos.set_cursor_visible(false)
	defos.set_cursor_clipped(true)
	M.cursor_movement = vmath.vector3(0)
	M.check()
end

function M.unlock_cursor()
	defos.set_cursor_visible(true)
	defos.set_cursor_clipped(false)
	M.cursor_movement = vmath.vector3(0)
	M.locked = false
end

function M.check()
	if M.locked then
		local x,y = defos.get_cursor_pos_view()
		M.cursor_movement.x = x-RENDERCAM.window.x/2
		M.cursor_movement.y = y-RENDERCAM.window.y/2
		defos.set_cursor_pos_view(RENDERCAM.window.x/2, RENDERCAM.window.y/2) -- In game view coordinates
	end
end

return M