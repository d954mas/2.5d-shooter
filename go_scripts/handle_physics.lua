local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local Script = COMMON.new_n28s()

function Script:init()
	self.msg_receiver = COMMON.MSG()
	self.msg_receiver:add(COMMON.HASHES.MSG_PHYSICS_CONTACT, self.on_physic_message)
	self.msg_receiver:add(COMMON.HASHES.MSG_PHYSICS_COLLISION, self.on_physic_message)
	self.source_url = msg.url()
	self.source_url.fragment = nil
end

function Script:on_physic_message(message_id, message, sender)
	GAME_CONTROLLER.level.physics_subject:onNext({message_id = message_id,message = message,sender = sender, source = self.source_url})
end


function Script:on_message(message_id, message, sender)
	self.msg_receiver:on_message(self, message_id, message, sender)
end

return Script