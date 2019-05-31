local COMMON = require "libs.common"
local ECS = require "libs.ecs"


local EcsWorld = COMMON.class("EcsWorld")

function EcsWorld:initialize()
	self.ecs = ECS.world()
	self:_init_systems()
end

function EcsWorld:_init_systems()

end

function EcsWorld:clear()
	self.ecs:clearEntities()
end

return EcsWorld



