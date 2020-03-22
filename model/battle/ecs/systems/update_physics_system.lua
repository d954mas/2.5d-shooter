local ECS = require 'libs.ecs'
---@class UpdatePhysicsSystem:ECSSystem
local System = ECS.system()
System.name = "UpdatePhysicsSystem"

---@param e Entity
function System:update(dt)
	physics3d.update()
end


return System