local ECS = require 'libs.ecs'
local BaseSystem = require "model.battle.ecs.systems.physics_collision_base_system"
---@class PhysicsCollisionsPickupsSystem:PhysicsCollisionBaseSystem
local System = BaseSystem.new()
System.name = "PhysicsCollisionsPickupsSystem"

---@param info NativePhysicsCollisionInfo
function System:is_handle_collision(info)
	local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
	return e2.pickup_object
end

---@param info NativePhysicsCollisionInfo
function System:handle_collision(info)
	local player, pickup = info.body1:get_user_data(), info.body2:get_user_data()

	self.world:removeEntity(pickup)
end


return System