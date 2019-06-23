local ECS = require 'libs.ecs'

---@class LookAtPlayerSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_sprite","rotation_look_at_player")

---@param e Entity
function System:process(e, dt)
	go.set_rotation(self.quaternion,e.url_sprite)
end

---@param e Entity
function System:preProcess( dt)
	self.quaternion = vmath.quat_rotation_y(self.world.world.level.player.angle.x)
end


return System