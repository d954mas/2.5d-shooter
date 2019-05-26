 local COMMON = require "libs.common"

--receiver message with position, then move gui to that position
---@class FollowGoScriptGoGui
local Script = COMMON.class("FollowGoScriptGoGui")

function Script:initialize(root_node)
	self.root_node = assert(root_node, "root_node can't be nil")
	self.msg_receiver = COMMON.MSG()
	self.msg_receiver:add(COMMON.HASHES.MSG_GUI_UPDATE_GO_POS, self.update_position)
end

function Script:update_position(message_id, message, sender)
	gui.set_position(self.root_node,assert(message.position))
end

function Script:on_message(go,message_id, message, sender)
	self.msg_receiver:on_message(self,message_id, message, sender)
end

return Script

