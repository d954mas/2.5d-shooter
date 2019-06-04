local ECS = require 'libs.ecs'
---@class DirectionToVelocitySystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("direction","pos","velocity")

---@param e Entity
function System:process(e, dt)
	e.velocity.x = e.direction.x
	e.velocity.y = e.direction.y
	if e.velocity.x ~= 0 and e.velocity.y ~= 0 then 
		e.velocity = vmath.normalize(e.velocity) 
	end
	if e.angle then e.velocity = -vmath.rotate(vmath.quat_rotation_z(-e.angle.x),e.velocity) end
end


return System