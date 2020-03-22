local ECS = require 'libs.ecs'

---@class PhysicsResetCorrectionsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("physics_obstacles_correction")
---@param e Entity
function System:process(e, dt)
	e.physics_obstacles_correction.x = 0
	e.physics_obstacles_correction.y = 0
	e.physics_obstacles_correction.z = 0
end

return System