local ECS = require 'libs.ecs'
---@class UpdatePhysicsBodyPosSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("physics_dynamic")
System.name = "UpdatePhysicsBodyPosSystem"

---@param e Entity
function System:process(e, dt)
	e.physics_body:set_position(e.position.x, e.position.y, e.position_z_center or e.position.z)
end


return System