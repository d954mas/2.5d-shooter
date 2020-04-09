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
	self:create_level_objects()
	self:create_lights()
end

function Creator:create_lights()
	for _, obj in ipairs(self.level.data.light_sources) do
		self.ecs:add_entity(self.entities:create_light_source(vmath.vector3(obj.cell_xf, obj.cell_yf, 0.8),obj.properties))
	end

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

function Creator:create_level_objects()
	for _, object in ipairs(self.level.data.level_objects) do
		self.ecs:add(self.entities:create_level_object(object))
	end
end

return Creator