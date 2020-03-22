local ECS = require 'libs.ecs'
---@class PhysicsCollisionsWallSystem:ECSSystem
local System = ECS.system()
System.name = "PhysicsCollisionsWallSystem"

---@param e Entity
function System:update(dt)
	local collisions = physics3d.get_collision_info()
	for _, info in ipairs(collisions) do
		if self:is_handle_collision(info) then
			self:handle_collision(info)
		end
	end
end

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

function System:handle_geometry(e, normal, distance)
	assert(e);
	assert(normal);
	assert(distance)
	local correction = assert(e.physics_obstacles_correction)
	if (vmath.length(normal * distance) <= 0) then return end
	if distance > 0 then
		local proj = vmath.project(correction, normal * distance)
		if proj < 1 then
			local comp = (distance - distance * proj) * normal
			e.position.x = e.position.x + comp.x
			e.position.y = e.position.y - comp.y
			e.physics_obstacles_correction = correction + comp
		end
	end
end

return System