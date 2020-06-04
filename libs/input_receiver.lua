local HASHES = require "libs.hashes"
local CLASS = require "libs.middleclass"

local M = CLASS.class("InputReceiver")
M.HASH_NIL = HASHES.NIL --used for mouse movement

M.PRESSED_KEYS = {}

local function ensure_hash(string_or_hash)
	return type(string_or_hash) == "string" and hash(string_or_hash) or string_or_hash
end

function M:initialize()
	self.action_funs = {}
end

function M:add_mouse(fun)
	assert(fun, "function can't be null")
	local action_id = M.HASH_NIL
	assert(not self.action_funs[action_id], action_id .. " already used")
	self.action_funs[action_id] = { fun = fun }
end

function M:add(action_id, fun, is_pressed, is_repeated, is_released)
	assert(action_id, "action_id can't be null")
	assert(fun, "function can't be null")
	action_id = ensure_hash(action_id)
	assert(not self.action_funs[action_id], action_id .. " already used")
	self.action_funs[action_id] = { fun = fun, is_pressed = is_pressed, is_repeated = is_repeated, is_released = is_released }
end

function M:on_input(go_self, action_id, action)
	action_id = action_id or M.HASH_NIL
	local fun = self.action_funs[action_id]
	if fun then
		if not (fun.is_pressed or fun.is_repeted) or (fun.is_pressed and action.pressed)
				or (fun.is_repeated and action.repeated) or (fun.is_released and action.released) then
			return fun.fun(go_self, action_id, action)
		end
	end
	return false
end

function M.clear()
	M.PRESSED_KEYS = {}
end

function M.handle_pressed_keys(action_id, action)
	if action.pressed then
		M.PRESSED_KEYS[action_id] = true
	elseif action.released then
		M.PRESSED_KEYS[action_id] = false
	end
end

function M.acquire(url)
	msg.post(url or ".", HASHES.INPUT.ACQUIRE_FOCUS)
end

function M.release(url)
	msg.post(url or ".", HASHES.INPUT.RELEASE_FOCUS)
end

return M
