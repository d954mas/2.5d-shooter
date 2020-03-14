local ECS = require 'libs.ecs'
---@class MovementSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("position","movement_direction","movement_velocity")

---@param e Entity
function System:process(e, dt)
	--normalize keyboard input
	if e.movement_direction.x ~= 0 and e.movement_direction.y~=0 then
		e.movement_direction = vmath.normalize(e.movement_direction)
	end
	--Inertia when change camera direction
	if  e.angle then e.movement_direction = vmath.rotate(vmath.quat_rotation_z(e.angle.x),e.movement_direction) end
	local target = e.movement_direction * (e.movement_max_speed)
	local accel =  vmath.dot(target,e.movement_velocity) > 0 and e.movement_accel or e.movement_deaccel

	e.movement_velocity = vmath.lerp(accel * dt, e.movement_velocity, target)

	e.position.x = e.position.x + e.movement_velocity.x*dt
	e.position.y = e.position.y + e.movement_velocity.y*dt
end


return System