local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "model.battle.ecs.systems"
local ENUMS = require "libs_project.enums"
local EVENTS = require "libs_project.events"
local Entities = require "model.battle.ecs.entities.entities"

---@class GameEcsWorld
local EcsWorld = COMMON.class("EcsWorld")

---@param world World
function EcsWorld:initialize(world)
	self.ecs = ECS.world()
	self.ecs.game = self
	self.world = assert(world)
	self.entities = Entities(world)
	self:_init_systems()
	self.ecs.on_entity_added = function(_, ...) self.entities:on_entity_added(...) end
	self.ecs.on_entity_updated = function(_, ...) self.entities:on_entity_updated(...) end
	self.ecs.on_entity_removed = function(_, ...) self.entities:on_entity_removed(...) end
	---@type Entity
	self.selected_object = nil
end

function EcsWorld:find_by_id(id)
	return self.entities:find_by_id(assert(id))
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
	--new and deletion object will be in next from
	--so prepare all for render. Then update positions.
	self.ecs:addSystem(SYSTEMS.UpdateCameraPositionSystem)
	self.ecs:addSystem(SYSTEMS.UpdateObjectColorSystem)
	self.ecs:addSystem(SYSTEMS.UpdateLightSystem)
	self.ecs:addSystem(SYSTEMS.LightsPatternUpdate)
	--self.ecs:addSystem(SYSTEMS.LightsDynamicUpdate)

	self.ecs:addSystem(SYSTEMS.InputSystem)
	self.ecs:addSystem(SYSTEMS.SelectObjectResetSystem)

	self.ecs:addSystem(SYSTEMS.DoorOpeningSystem)

	self.ecs:addSystem(SYSTEMS.UpdateAISystem)

	self.ecs:addSystem(SYSTEMS.MovementSystem)

	self.ecs:addSystem(SYSTEMS.RotationSpeedSystem)
	self.ecs:addSystem(SYSTEMS.RotationLookAtPlayerSystem)
	self.ecs:addSystem(SYSTEMS.RotationGlobalSystem)

	self.ecs:addSystem(SYSTEMS.UpdatePhysicsBodyPositionsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsResetCorrectionSystem)
	self.ecs:addSystem(SYSTEMS.UpdatePhysicsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsCollisionWallSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsCollisionPickupSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsCollisionBulletPlayerSystem)

	self.ecs:addSystem(SYSTEMS.UpdateGoSystem)

	self.ecs:addSystem(SYSTEMS.WeaponPlayerUpdateSystem)
	self.ecs:addSystem(SYSTEMS.CameraBobSystem)

	self.ecs:addSystem(SYSTEMS.UpdateCameraVisibleCellsSystem)
	self.ecs:addSystem(SYSTEMS.CheckVisibleSystem)

	self.ecs:addSystem(SYSTEMS.SelectObjectDoorSystem)
	self.ecs:addSystem(SYSTEMS.SelectObjectShowTitleSystem)

	self.ecs:addSystem(SYSTEMS.DrawCeilSystem)
	self.ecs:addSystem(SYSTEMS.DrawFloorSystem)
	self.ecs:addSystem(SYSTEMS.DrawWallSystem)
	self.ecs:addSystem(SYSTEMS.DrawDoorSystem)
	self.ecs:addSystem(SYSTEMS.AnimationWallSystem)
	self.ecs:addSystem(SYSTEMS.DrawLevelObjectSystem)
	self.ecs:addSystem(SYSTEMS.DrawPickupsSystem)
	self.ecs:addSystem(SYSTEMS.DrawBulletSystem)
	self.ecs:addSystem(SYSTEMS.DrawDebugPhysicsBodiesSystem)
	self.ecs:addSystem(SYSTEMS.DrawDebugLightsSystem)
	self.ecs:addSystem(SYSTEMS.WeaponPlayerTintSystem)
	self.ecs:addSystem(SYSTEMS.AutoDestroySystem)
end

function EcsWorld:load_level()
	assert(not self.level_loaded)
	self.level_loaded = true
	self.level = self.world.battle_model.level
	self:_load_player()
end

function EcsWorld:_load_player()
	self.player = self.entities:create_player(vmath.vector3(self.level.data.player.position.x, self.level.data.player.position.y, 0))
	self.player.angle.x = self.level.data.player.angle
	self:add_entity(self.player)
end

function EcsWorld:player_inventory_add_key(key)
	checks("?", "string")
	self.player.player_inventory.keys[key] = true
end

function EcsWorld:player_weapon_get_active()
	for _, weapon in pairs(self.player.weapons) do
		if (weapon:state_is_active()) then return weapon end
	end
	error("no active assert")
end

function EcsWorld:player_weapon_get(key)
	checks("?", "string")
	return assert(self.player.weapons[key], "unknown weapon:" .. key)
end

function EcsWorld:player_weapon_change(new_weapon_key)
	checks("?", "string")
	local new_weapon = self:player_weapon_get(new_weapon_key)
	local current = self:player_weapon_get_active()
	if (current == new_weapon) then return end

	COMMON.i(string.format("weapon change from:%s to:%s", current.config.key, new_weapon.config.key))
	current:state_active_set(false)
	new_weapon:state_active_set(true)
	COMMON.EVENT_BUS:event(EVENTS.GAME_PLAYER_WEAPON_CHANGED)
end

function EcsWorld:player_can_heal()
	return self.player.hp.current < self.player.hp.max
end

function EcsWorld:player_heal(value)
	assert(self:player_can_heal())
	local hp = self.player.hp
	hp.current = COMMON.LUME.clamp(hp.current + value, 0, hp.max)
end

---@param e Entity
---@return NativePhysicsRaycastInfo[]
function EcsWorld:raycast(e, dist, mask)
	local pos = vmath.vector3(e.position.x, e.position.y, 0)
	local pos_end = vmath.normalize(vmath.rotate(vmath.quat_rotation_z(e.angle.x), pos))
	pos_end = pos + pos_end * dist
	return physics3d.raycast(pos.x, pos.y, pos.z, pos_end.x, pos_end.y, pos_end.z, mask)

end

function EcsWorld:update(dt)
	self.ecs:update(dt)
end

---@param e Entity
function EcsWorld:select_object(e)
	self.selected_object = e
end

function EcsWorld:select_object_interact()
	assert(self.selected_object)
	if (self.selected_object.door and self.selected_object.door_data.closed) then
		local dd = self.selected_object.door_data
		if (not dd.key or self.player.player_inventory.keys[dd.key]) then
			self:door_open(self.selected_object)
		end
	end
end

---@param e Entity
function EcsWorld:door_open(e)
	assert(e)
	assert(e.door)
	local dd = self.selected_object.door_data
	assert(not dd.key or self.player.player_inventory.keys[dd.key])
	dd.closed = false
	dd.opening = true
end

function EcsWorld:clear()
	self.ecs:clear()
	self.ecs:refresh()
end

function EcsWorld:add(...)
	self.ecs:add(...)
end

function EcsWorld:add_entity(e)
	self.ecs:addEntity(e)
end

function EcsWorld:remove_entity(e)
	self.ecs:removeEntity(e)
end

return EcsWorld



