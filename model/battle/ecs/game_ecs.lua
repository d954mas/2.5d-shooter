local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "model.battle.ecs.systems"


local EcsWorld = COMMON.class("EcsWorld")

---@param world World
function EcsWorld:initialize(world)
	self.ecs = ECS.world()
	self.world = assert(world)
	self:_init_systems()
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
	self.ecs:addSystem(SYSTEMS.InputSystem)
	self.ecs:addSystem(SYSTEMS.UpdateAISystem)

	self.ecs:addSystem(SYSTEMS.MovementSystem)

	self.ecs:addSystem(SYSTEMS.RotationLookAtPlayerSystem)
	self.ecs:addSystem(SYSTEMS.RotationGlobalSystem)

	self.ecs:addSystem(SYSTEMS.UpdateGoSystem)
	
	self.ecs:addSystem(SYSTEMS.CameraBobSystem)
	self.ecs:addSystem(SYSTEMS.UpdateCameraSystem)

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



