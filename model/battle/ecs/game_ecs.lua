local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "model.battle.ecs.systems"
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
	self.ecs.on_entity_added = function(...) self.entities:on_entity_added(...) end
	self.ecs.on_entity_updated = function(...) self.entities:on_entity_updated(...) end
	self.ecs.on_entity_removed = function(...) self.entities:on_entity_removed(...) end
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
	self.ecs:addSystem(SYSTEMS.UpdateCameraPositionSystem)
	self.ecs:addSystem(SYSTEMS.InputSystem)
	self.ecs:addSystem(SYSTEMS.UpdateAISystem)

	self.ecs:addSystem(SYSTEMS.MovementSystem)

	self.ecs:addSystem(SYSTEMS.RotationLookAtPlayerSystem)
	self.ecs:addSystem(SYSTEMS.RotationGlobalSystem)

	self.ecs:addSystem(SYSTEMS.UpdatePhysicsBodyPositionsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsResetCorrectionSystem)
	self.ecs:addSystem(SYSTEMS.UpdatePhysicsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsCollisionWallSystem)

	self.ecs:addSystem(SYSTEMS.UpdateGoSystem)

	self.ecs:addSystem(SYSTEMS.CameraBobSystem)

	self.ecs:addSystem(SYSTEMS.UpdateCameraVisibleCellsSystem)
	self.ecs:addSystem(SYSTEMS.CheckVisibleSystem)
	self.ecs:addSystem(SYSTEMS.DrawCeilSystem)
	self.ecs:addSystem(SYSTEMS.DrawFloorSystem)
	self.ecs:addSystem(SYSTEMS.DrawWallSystem)
	self.ecs:addSystem(SYSTEMS.DrawDebugPhysicsBodiesSystem)
	self.ecs:addSystem(SYSTEMS.UpdateObjectColorSystem)
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
	self.player.angle.x = math.rad(self.level.data.player.angle)
	self:add_entity(self.player)
end

function EcsWorld:update(dt)
	self.ecs:update(dt)
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



