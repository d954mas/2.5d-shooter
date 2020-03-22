local ECS = require 'libs.ecs'
---@class MovementSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("position","movement")
System.name = "MovementSystem"

---@param e Entity
function System:process(e, dt)
	--normalize keyboard input
	if e.movement.direction.x ~= 0 and e.movement.direction.y~=0 then
		e.movement.direction = vmath.normalize(e.movement.direction)
	end
	--Inertia when change camera direction
	if  e.angle then e.movement.direction = vmath.rotate(vmath.quat_rotation_z(e.angle.x),e.movement.direction) end
	local target = e.movement.direction * (e.movement.max_speed)
	local accel =  vmath.dot(target,e.movement.velocity) > 0 and e.movement.accel or e.movement.deaccel

	e.movement.velocity = vmath.lerp(accel * dt, e.movement.velocity, target)

	e.position.x = e.position.x + e.movement.velocity.x*dt
	e.position.y = e.position.y + e.movement.velocity.y*dt
end


return System