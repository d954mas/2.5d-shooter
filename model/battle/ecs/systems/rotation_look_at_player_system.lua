local ECS = require 'libs.ecs'

---@class RotationLookAtPlayerSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("rotation_look_at_player")
System.name = "RotationLookAtPlayerSystem"

---@param e Entity
function System:process(e, dt)
	e.rotation_look_at_player_quaternion = self.quaternion
end

---@param e Entity
function System:preProcess(dt)
	self.quaternion = vmath.quat_rotation_y(self.world.game.player.angle.x)
end

return System