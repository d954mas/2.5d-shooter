local BaseSystem = require "model.battle.ecs.systems.physics_collision_base_system"
---@class PhysicsCollisionsWallSystem:PhysicsCollisionBaseSystem
local System = BaseSystem.new()
System.name = "PhysicsCollisionsWallSystem"

---@param info NativePhysicsCollisionInfo
function System:is_handle_collision(info)
	local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
	return e1.wall or e2.wall
end

---@param info NativePhysicsCollisionInfo
function System:handle_collision(info)
	local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
	local wall_first  = e1.wall and true or false;
	local manifold = info.manifolds[1]
	local point = manifold.points[1]
	self:handle_geometry(wall_first and e2 or e1, vmath.vector3(-point.normal.x, point.normal.y, point.normal.z), point.depth)
end
---@param e Entity
function System:handle_geometry(e, normal, distance)
	assert(e);
	assert(normal);
	assert(distance)
	local correction = assert(e.physics_obstacles_correction)
	local nd = normal * distance
	if (vmath.length(nd) <= 0) then return end
	if distance > 0 then
		local proj = vmath.project(correction, nd)
		if proj < 1 then

			local comp = (distance - distance * proj) * normal
		--	pprint(e.movement.velocity)
			--little bit reduce velocity when collide with wall.Only for one collision per frame
			--empirical formula
			if(e.physics_obstacles_correction.x ==0 and e.physics_obstacles_correction.y == 0)then
				local power_x = math.min(math.abs(nd.x)*55,1)
				local power_y = math.min(math.abs(nd.y)*55,1)
				e.movement.velocity.x = e.movement.velocity.x - e.movement.velocity.x*0.1*power_x
				e.movement.velocity.y = e.movement.velocity.y - e.movement.velocity.y*0.1*power_y
			end


			e.position.x = e.position.x + comp.x
			e.position.y = e.position.y - comp.y
			e.physics_obstacles_correction = correction + comp
		end
	end
end

return System