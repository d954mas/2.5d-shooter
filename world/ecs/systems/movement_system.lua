local ECS = require 'libs.ecs'
---@class MovementSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("position","velocity","speed")

---@param e Entity
function System:process(e, dt)
	e.velocity = vmath.length(e.velocity) ~= 0 and vmath.normalize(e.velocity) or e.velocity
	local movement = e.velocity * e.speed * dt
	e.position.x = e.position.x + movement.x
	e.position.y = e.position.y + movement.y
end


return System