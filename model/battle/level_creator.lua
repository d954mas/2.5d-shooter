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
	self:create_walls_floor_and_ceil()
	self:create_level_objects()
	self:create_pickup_objects()
	self:create_lights()
	self:create_doors()
end

function Creator:create_lights()
	for _, obj in ipairs(self.level.data.light_sources) do
		self.ecs:add_entity(self.entities:create_light_source(vmath.vector3(obj.cell_xf, obj.cell_yf, 0.8), obj.properties))
	end
end

function Creator:create_doors()
	for _, obj in ipairs(self.level.data.doors) do
		self.ecs:add_entity(self.entities:create_door(obj))
	end
end

function Creator:create_walls_floor_and_ceil()
	local add_floor, add_ceil = true, true
	local data = self.level.data
	local floors, ceils, walls = data.floor, data.ceil, data.walls
	local ecs, entities = self.ecs, self.entities
	for id = 0, self.level.cell_max_id, 1 do
		local floor = add_floor and floors[id]
		local ceil = add_ceil and ceils[id]
		if (floor) then ecs:add_entity(entities:create_floor(id)) end
		if (ceil) then ecs:add_entity(entities:create_ceil(id)) end

		local wall = walls[id]
		if (wall.base ~= 0 or wall.south or wall.north or wall.west or wall.east) then
			ecs:add_entity(entities:create_wall(id))
		end
	end
end

function Creator:create_level_objects()
	for _, object in ipairs(self.level.data.level_objects) do
		self.ecs:add(self.entities:create_level_object(object))
	end
end

function Creator:create_pickup_objects()
	for _, object in ipairs(self.level.data.pickups) do
		print("add pickups")
		self.ecs:add(self.entities:create_pickup_object(object))
	end
end

return Creator