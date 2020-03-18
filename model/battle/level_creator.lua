local COMMON = require "libs.common"

local Creator = COMMON.class("LevelCreator")

---@param world World
function Creator:initialize(world)
	self.world = world
	self.level = world.battle_model.level
	self.ecs = world.battle_model.ecs
	self.entities = self.ecs.entities
end

function Creator:create()
	self:create_floor()
	self:create_ceil()
end

function Creator:create_floor()
	for id=0,#self.level.data.floor-1,1 do
		self.ecs:add_entity(self.entities:create_floor(id))
	end
end
function Creator:create_ceil()
	for id=0,#self.level.data.ceil-1,1 do
		self.ecs:add_entity(self.entities:create_ceil(id))
	end
end

return Creator