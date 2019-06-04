local ECS = require 'libs.ecs'
---@class MovementSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("direction","pos","velocity","speed")

---@param e Entity
function System:process(e, dt)
	local movement = e.velocity * e.speed * dt
	e.pos.x = e.pos.x + movement.x
	e.pos.y = e.pos.y + movement.y
end


return System