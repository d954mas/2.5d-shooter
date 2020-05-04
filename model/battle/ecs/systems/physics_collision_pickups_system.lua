local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"

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
	if(pickup.pickup_type == ENUMS.PICKUP_TYPE.KEY) then
		self.world.game:player_inventory_add_key(pickup.pickup_key_type)
		self.world:removeEntity(pickup)
	elseif(pickup.pickup_type == ENUMS.PICKUP_TYPE.HP) then
		if(self.world.game:player_can_heal())then
			self.world.game:player_heal(CONSTANTS.GAME_CONFIG.HP_1_HEAL)
			self.world:removeEntity(pickup)
		end
	else
		self.world:removeEntity(pickup)
	end

end


return System