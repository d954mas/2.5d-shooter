local COMMON = require "libs.common"
local RENDERCAM = require "rendercam.rendercam"
local IS_HTML = sys.get_sys_info().system_name == "HTML5"

--LOCK CURSOR LIKE IN SHOOTER.
local M = {}
M.focus = true
M.cursor_movement = vmath.vector3(0)
function M.register_listeners()
	window.set_listener(function (self,event,sss)
		M.prev_state = not M.locked
		if event == window.WINDOW_EVENT_FOCUS_LOST then
			M.unlock_cursor()
			M.focus = false
		elseif event == window.WINDOW_EVENT_FOCUS_GAINED then
			M.focus = true
			if M.prev_state then
				M.lock_cursor()
				M.prev_state = nil
			end
		end
	end)
	if IS_HTML then
		defos.on_click(function ()
			if M.locked then
				defos.set_cursor_locked(true)
			else
				defos.set_cursor_locked(false)
			end
		end)
	end
end

function M.unregister_listener()
	window.set_listener(function () end)
	if IS_HTML then defos.on_click(function () end) end
end

function M.lock_cursor()
	if not M.focus then return true end
	M.locked = true
	M.cursor_movement = vmath.vector3(0)
	if not IS_HTML then
		defos.set_cursor_visible(false)
		defos.set_cursor_clipped(true)
		M.update_cursor_movement()
	end
end

function M.on_input(action_id,action)
	if IS_HTML then
		if action_id == nil then
			M.cursor_movement.x = action.dx
			M.cursor_movement.y = action.dy
		end
	else
		if action_id == COMMON.HASHES.INPUT_ESC then
			if M.locked then
				M.unlock_cursor()
				M.wait_for_touch = true -- enable lock when user touch inside game window
			end
		elseif action_id == COMMON.HASHES.INPUT_TOUCH and action.pressed and M.wait_for_touch then
			M.lock_cursor()
			M.wait_for_touch = false
		end
	end
end

function M.unlock_cursor()
	if IS_HTML then
		defos.set_cursor_locked(false)
	else
		defos.set_cursor_visible(true)
		defos.set_cursor_clipped(false)
	end
	M.cursor_movement = vmath.vector3(0)
	M.locked = false
end

function M.update_cursor_movement()
	if not IS_HTML then
		if M.locked then
			local x,y = defos.get_cursor_pos_view()
			M.cursor_movement.x = x-RENDERCAM.window.x/2
			M.cursor_movement.y = y-RENDERCAM.window.y/2
			defos.set_cursor_pos_view(RENDERCAM.window.x/2, RENDERCAM.window.y/2) -- In game view coordinates
		end
	end
end

return M