local requiref = require
local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.ecs.systems"


local EcsWorld = COMMON.class("EcsWorld")

function EcsWorld:initialize()
	self.ecs = ECS.world()
	self.ecs.world = requiref("world.world")
	self:_init_systems()
end

function EcsWorld:_init_systems()
	self.ecs:addSystem(SYSTEMS.InputSystem)
	self.ecs:addSystem(SYSTEMS.DirectionToVelocitySystem)
	self.ecs:addSystem(SYSTEMS.PhysicsResetCorrectionsSystem)
	self.ecs:addSystem(SYSTEMS.PhysicsObstaclesSystem)
	self.ecs:addSystem(SYSTEMS.MovementSystem)
	self.ecs:addSystem(SYSTEMS.DrawObjectsSystem)
	self.ecs:addSystem(SYSTEMS.DrawWallsSystem)

	self.ecs:addSystem(SYSTEMS.LookAtPlayerSystem)
	self.ecs:addSystem(SYSTEMS.GlobalRotationSystem)
	self.ecs:addSystem(SYSTEMS.UpdateGoSystem)
	self.ecs:addSystem(SYSTEMS.CameraSystem)

end

function EcsWorld:update(dt)
	self.ecs:update(dt)
end

function EcsWorld:clear()
	self.ecs:clearEntities()
end

return EcsWorld



