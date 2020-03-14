local ECS = require 'libs.ecs'

---@class RotationGlobalSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_sprite","rotation_global")
System.name = "RotationGlobalSystem"

---@param e Entity
function System:process(e, dt)
	go.set_rotation(self.quaternion,e.url_sprite)
end

---@param e Entity
function System:preProcess( dt)
	--self.world.game_controller.level.rotation_global = self.world.game_controller.level.rotation_global + 2 * dt
	--self.quaternion = vmath.quat_rotation_y(self.world.game_controller.level.rotation_global)
end

return System