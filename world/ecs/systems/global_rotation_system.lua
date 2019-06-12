local ECS = require 'libs.ecs'

---@class GlobalRotationSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("sprite_url","global_rotation")

---@param e Entity
function System:process(e, dt)
	go.set_rotation(self.quaternion,e.sprite_url)
end

---@param e Entity
function System:preProcess( dt)
	self.world.world.level.global_rotation = self.world.world.level.global_rotation + 2 * dt
	self.quaternion = vmath.quat_rotation_y(self.world.world.level.global_rotation)
end

return System