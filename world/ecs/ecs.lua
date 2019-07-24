local requiref = require
local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.ecs.systems"


local EcsWorld = COMMON.class("EcsWorld")

function EcsWorld:initialize()
	self.ecs = ECS.world()
	self.ecs.game_controller = requiref("scenes.game.model.game_controller")
	self:_init_systems()
	self.systems = SYSTEMS
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
	self.ecs:addSystem(SYSTEMS.UpdateAISystem)
	self.ecs:addSystem(SYSTEMS.UpdateWeaponsSystem)
	self.ecs:addSystem(SYSTEMS.InputSystem)
	self.ecs:addSystem(SYSTEMS.CollisionDamageRotateSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsResetCorrectionsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsObstaclesSystem)
	self.ecs:addSystem(SYSTEMS.MovementSystem)

	self.ecs:addSystem(SYSTEMS.DrawObjectsSystem)
	self.ecs:addSystem(SYSTEMS.DrawWallsSystem)

	self.ecs:addSystem(SYSTEMS.RotationLookAtPlayerSystem)
	self.ecs:addSystem(SYSTEMS.RotationGlobalSystem)

	self.ecs:addSystem(SYSTEMS.DamageSystem)
	self.ecs:addSystem(SYSTEMS.ObjectHitSystem)
	self.ecs:addSystem(SYSTEMS.FlashSystem)


	self.ecs:addSystem(SYSTEMS.UpdateGoSystem)
	self.ecs:addSystem(SYSTEMS.CameraBobSystem)
	self.ecs:addSystem(SYSTEMS.CameraSystem)

	self.ecs:addSystem(SYSTEMS.UpdateObjectColorSystem)
	self.ecs:addSystem(SYSTEMS.AutoDestroySystem)


end

function EcsWorld:update(dt)
	self.ecs:update(dt)
end

function EcsWorld:clear()
	self.ecs:clear()
end

function EcsWorld:add(...)
	self.ecs:add()
end

function EcsWorld:add_entity(e)
	self.ecs:addEntity(e)
end

function EcsWorld:remove_entity(e)
	self.ecs:removeEntity(e)
end

return EcsWorld



