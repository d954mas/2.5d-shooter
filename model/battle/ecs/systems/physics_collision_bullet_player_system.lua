local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"

local BaseSystem = require "model.battle.ecs.systems.physics_collision_base_system"
---@class PhysicsCollisionsBulletSystem:PhysicsCollisionBaseSystem
local System = BaseSystem.new()
System.name = "PhysicsCollisionsBulletSystem"

---@param info NativePhysicsCollisionInfo
function System:is_handle_collision(info)
	local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
	return e2.bullet
end

---@param info NativePhysicsCollisionInfo
function System:handle_collision(info)
	local object, bullet = info.body1:get_user_data(), info.body2:get_user_data()
	self.world:removeEntity(bullet)
	pprint("remove")

end


return System