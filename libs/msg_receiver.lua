local CLASS = require "libs.middleclass"
local M = CLASS.class("InputReceiver")

local function ensure_hash(string_or_hash)
	return type(string_or_hash) == "string" and hash(string_or_hash) or string_or_hash
end


function M:initialize()
	self.msg_funs = {}
end

function M:add(message_id,fun)
	assert(message_id,"message_id can't be null")
	assert(fun,"function can't be null")
	message_id = ensure_hash(message_id)
	assert(not self.msg_funs[message_id], message_id .. " already used")
	self.msg_funs[message_id] = fun
end

function M:on_message(go_self, message_id, message, sender)
	local fun = self.msg_funs[message_id]
	if fun then
		fun(go_self, message_id, message, sender)
		return true
	end
	return false
end

return M
