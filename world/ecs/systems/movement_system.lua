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
	--first type. Inertia when change camera direction
	if not toggle_1 and  e.angle then e.movement_direction = vmath.rotate(vmath.quat_rotation_z(e.angle.x),e.movement_direction) end
	local target = e.movement_direction * (e.movement_max_speed or 3)
	local accel
	--Take the dot product of target to see if the player is moving according to target
	if vmath.dot(target,e.movement_velocity) > 0 then
		accel = e.movement_accel or 3
	else
		accel =  e.movement_deaccel or 6
	end

	e.movement_velocity = vmath.lerp(accel * dt, e.movement_velocity,target)
	local vel = vmath.vector3(e.movement_velocity)
	--second type Inertia only when change direction(keyboard keys)
	if toggle_1 and e.angle then vel = vmath.rotate(vmath.quat_rotation_z(e.angle.x),vel) end

	e.position.x = e.position.x + vel.x*dt
	e.position.y = e.position.y + vel.y*dt
end


return System