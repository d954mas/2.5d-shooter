local M = {}
M.hashes = {}
setmetatable(M.hashes, {
	__index = function(t, key)
		local h = hash(key)
		rawset(t, key, h)
		return h
	end
})

function M.hash(key)
	return M.hashes[key]
end

M.INPUT = {
	ACQUIRE_FOCUS = hash("acquire_input_focus"),
	RELEASE_FOCUS = hash("release_input_focus"),
	BACK = hash("back"),
	TOUCH = hash("touch"),
	RIGHT_CLICK = hash("right_click"),
	ESK = hash("esk"),
	UP = hash("up"),
	DOWN = hash("down"),
	LEFT = hash("left"),
	RIGHT = hash("right"),
	INTERACT = hash("interact"),
	WEAPON_1 = hash("weapon_1"),
	WEAPON_2 = hash("weapon_2"),
	WEAPON_3 = hash("weapon_3"),
	WEAPON_4 = hash("weapon_4"),
}

M.MSG = {
	PHYSICS = {
		CONTACT_POINT_RESPONSE = hash("contact_point_response"),
		COLLISION_RESPONSE = hash("collision_response"),
		TRIGGER_RESPONSE = hash("trigger_response"),
		RAY_CAST_RESPONSE = hash("ray_cast_response")
	},
	RENDER = {
		CLEAR_COLOR = hash("clear_color"),
		SET_VIEW_PROJECTION = hash("set_view_projection"),
		WINDOW_RESIZED = hash("window_resized"),
		DRAW_LINE = hash("draw_line"),
	},
	PLAY_SOUND = hash("play_sound"),
	ENABLE = hash("enable"),
	DISABLE = hash("disable"),
	PLAY_ANIMATION = hash("play_animation"),
	ACQUIRE_CAMERA_FOCUS = hash("acquire_camera_focus"),
	SET_PARENT = hash("set_parent"),
	SET_TIME_STEP = hash("set_time_step"),
	LOADING = {
		PROXY_LOADED = hash("proxy_loaded"),
		ASYNC_LOAD = hash("async_load"),
		UNLOAD = hash("unload"),
	},
	TINT = {
		TINT = hash("tint"),
		X = hash("tint.x"),
		Y = hash("tint.y"),
		Z = hash("tint.z"),
		W = hash("tint.w"),
	}
}

M.MSG_SM_INIT = hash("msg_sm_init")
M.MSG_SM_SHOW = hash("msg_sm_show")
M.MSG_SM_HIDE = hash("msg_sm_hide")
M.MSG_SM_PAUSE = hash("msg_sm_pause")
M.MSG_SM_RESUME = hash("msg_sm_resume")
M.MSG_SM_TRANSITION = hash("msg_sm_transition")
M.MSG_SM_LOAD = hash("msg_sm_load")

M.EMPTY = hash("empty")
M.NIL = hash("nil")
M.SPRITE = hash("sprite")

return M
