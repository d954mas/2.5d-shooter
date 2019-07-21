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

	local cell = self.world.game_controller.level:map_get_cell(math.ceil(e.position.x),math.ceil(e.position.y))
	local floor_tile = self.world.game_controller.level:get_tile(cell.wall.floor)
	--friction.If have friction interpolate target vector to current_movement_vector
	local floor_multiply
	--Take the dot product of target to see if the player is moving according to target
	if vmath.dot(target,e.movement_velocity) > 0 then
		accel = (e.movement_accel or 3)
		floor_multiply = floor_tile.properties.deacceleration_multiply or 1
	else
		accel =  (e.movement_deaccel or 6)
		floor_multiply = floor_tile.properties.acceleration_multiply or 1
	end


	if floor_multiply ~= 0 then
		--if target.x ~=0 and target.y ~= 0 then
			--target = vmath.normalize(target)
		--end
		local dist = vmath.length(target - e.movement_velocity)
		--or will be slow down very long time
		if dist > 0.4 then
			target = vmath.lerp(floor_multiply,e.movement_velocity,target)
		end
	end

	e.movement_velocity = vmath.lerp(accel * dt, e.movement_velocity,target )
	local vel = vmath.vector3(e.movement_velocity)
	--second type Inertia only when change direction(keyboard keys)
	if toggle_1 and e.angle then vel = vmath.rotate(vmath.quat_rotation_z(e.angle.x),vel) end

	e.position.x = e.position.x + vel.x*dt
	e.position.y = e.position.y + vel.y*dt
end


return System