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
	self:create_wall()
end

function Creator:create_floor()
	for id = 0, self.level.cell_max_id, 1 do
		local floor = self.level.data.floor[id]
		if (floor) then
			self.ecs:add_entity(self.entities:create_floor(id))
		end
	end
end
function Creator:create_ceil()
	for id = 0, self.level.cell_max_id, 1 do
		local ceil = self.level.data.ceil[id]
		if (ceil) then
			self.ecs:add_entity(self.entities:create_ceil(id))
		end
	end
end
function Creator:create_wall()
	for id = 0, self.level.cell_max_id, 1 do
		local wall = self.level.data.walls[id]
		if (wall.base ~= 0 or wall.south or wall.north or wall.west or wall.east) then
			self.ecs:add_entity(self.entities:create_wall(id))
		end

	end
end

return Creator