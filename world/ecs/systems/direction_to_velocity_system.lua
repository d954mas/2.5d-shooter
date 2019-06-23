local ECS = require 'libs.ecs'
---@class DirectionToVelocitySystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("input_direction","position","velocity")

---@param e Entity
function System:process(e, dt)

end


return System