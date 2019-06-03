local ECS = require 'libs.ecs'
local CURSOR_HELPER = require "libs.cursor_helper"
local CAMERA_URL = msg.url("game:/camera")


---@class InputSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("input","input_action_id","input_action")

function System:input_mouse_move(action)
	local player = self.world.world.level.player
	player.angle.x = player.angle.x -CURSOR_HELPER.cursor_movement.x/540
end

---@param e Entity
function System:process(e, dt)
	if e.input_action_id == nil then
		self:input_mouse_move(e.input_action)
	end
	self.world:removeEntity(e)
end


return System