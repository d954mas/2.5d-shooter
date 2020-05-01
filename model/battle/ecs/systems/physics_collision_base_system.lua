local ECS = require 'libs.ecs'
---@class PhysicsCollisionBaseSystem:ECSSystem
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

end

function System.new()
	local self = {}
	setmetatable(self, { __index = System })
	return self
end

return System