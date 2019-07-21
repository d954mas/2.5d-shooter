local ECS = require 'libs.ecs'

--collision should always look at player
---@class CollisionDamageRotateSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_collision_damage")

---@param e Entity
function System:process(e, dt)
	if not e.player then
		go.set_rotation(self.quaternion,e.url_collision_damage)
	end
end

---@param e Entity
function System:preProcess( dt)
	self.quaternion = vmath.quat_rotation_y(self.world.game_controller.level.player.angle.x)
end


return System