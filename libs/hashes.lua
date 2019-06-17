local M = {}

M.INPUT_ACQUIRE_FOCUS = hash("acquire_input_focus")
M.INPUT_RELEASE_FOCUS = hash("release_input_focus")

M.INPUT_BACK = hash("back")
M.INPUT_TOGGLE_PROFILER = hash("toggle_profile")
M.INPUT_TOGGLE_PHYSICS = hash("toggle_physics")
M.INPUT_TOGGLE_DEBUG_GUI = hash("toggle_debug_gui")

M.INPUT_UP = hash("up")
M.INPUT_LEFT = hash("left")
M.INPUT_RIGHT = hash("right")
M.INPUT_DOWN = hash("down")
M.INPUT_SPACE = hash("space")
M.INPUT_ESC = hash("escape")

M.INPUT_TOUCH = hash("touch")
M.INPUT_RIGHT_CLICK = hash("right_click")

M.MSG_SYSTEM_TOGGLE_PROFILER = hash("toggle_profile")

M.MSG_PHYSICS_CONTACT = hash("contact_point_response")
M.MSG_PHYSICS_COLLISION = hash("collision_response")
M.MSG_PHYSICS_TRIGGER = hash("trigger_response")
M.MSG_PHYSICS_RAY_CAST= hash("ray_cast_response")

M.MSG_RENDER_CLEAR_COLOR = hash("clear_color")
M.MSG_RENDER_SET_VIEW_PROJECTION = hash("set_view_projection")
M.MSG_RENDER_WINDOW_RESIZED = hash("window_resized")
M.MSG_RENDER_DRAW_LINE = hash("draw_line")
M.MSG_PLAY_SOUND = hash("play_sound")
M.MSG_ENABLE = hash("enable")
M.MSG_DISABLE = hash("disable")
M.MSG_PLAY_ANIMATION = hash("play_animation")
M.MSG_ACQUIRE_CAMERA_FOCUS = hash("acquire_camera_focus")
M.MSG_SET_PARENT = hash("set_parent")
M.RGB = hash("rgb")

M.MSG_GUI_UPDATE_GO_POS = hash("msg_gui_update_go_pos")
M.MSG_POST_UPDATE = hash("msg_post_update")


M.MSG_PROXY_LOADED = hash("proxy_loaded")
M.MSG_ASYNC_LOAD = hash("async_load")
M.MSG_UNLOAD = hash("unload")

M.MSG_SM_INIT = hash("msg_sm_init")
M.MSG_SM_SHOW = hash("msg_sm_show")
M.MSG_SM_HIDE = hash("msg_sm_hide")
M.MSG_SM_PAUSE = hash("msg_sm_pause")
M.MSG_SM_RESUME = hash("msg_sm_resume")
M.MSG_SM_TRANSITION = hash("msg_sm_transition")
M.MSG_SM_LOAD = hash("msg_sm_load")


M.EMPTY = hash("empty")


function M.ensure_hash(string_or_hash)
	return type(string_or_hash) == "string" and hash(string_or_hash) or string_or_hash
end

return M
