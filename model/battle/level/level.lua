local COMMON = require "libs.common"
local TILESET = require "model.battle.level.tileset"
local MAP_HELPER = require "assets.levels.parser.map_helper"

local table_insert = table.insert
--Cell used in cpp and in lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0
local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")

---@param walls LevelDataWallBlock[]
local function walls_prepare_to_native(walls, cell_max_id)
	for i = 0, cell_max_id do
		local wall = walls[i]
		if (wall) then
			local tile = TILESET.by_id[wall.base.tile_id]
			wall.blocked = tile.properties.blocked
			wall.transparent = tile.properties.transparent
		else
			wall = { base = 0 }
			walls[i] = wall
		end
	end
end

---@param objects LevelMapObject[]
local function objects_set_meta(objects)
	for _, object in pairs(objects) do
		setmetatable(object.properties, { __index = TILESET.by_id[object.tile_id].properties })
	end
end

local function set_default_color(light_map, max_id, default_color)
	for id = 0, max_id do
		if (light_map[id] == -1) then light_map[id] = default_color end
		light_map[id] = bit.tobit(light_map[id])
	end
end

---@param data LevelData
function Level:initialize(data)
	self.data = assert(data)
	self.cell_max_id = self.data.size.x * self.data.size.y - 1
	walls_prepare_to_native(self.data.walls, self.cell_max_id)
	objects_set_meta(data.level_objects)
	objects_set_meta(data.light_sources)
	objects_set_meta(data.doors)
	objects_set_meta(data.pickups)
	set_default_color(data.light_map, self.cell_max_id, 0xFFFFFFFF)
end

--region MAP
function Level:map_get_width() return self.data.size.x end
function Level:map_get_height() return self.data.size.y end

--[[
Childs number when get all childs for X cell
 _ _ _
|1|2|3|
 ‾ ‾ ‾
 _ _ _
|8|X|4|
 ‾ ‾ ‾
 _ _ _
|7|6|5|
 ‾ ‾ ‾
--]]
--zero value is always cell_id cell
--todo add cache here
---@return NativeCellData[]  list
---@return NativeCellData[][] matrix
function Level:map_get_neighbours(cell_id, dist)
	assert(cell_id)
	assert(self:map_cell_id_in(cell_id))
	local cell = native_raycasting.cells_get_by_id(cell_id)
	local cell_x, cell_y = cell:get_x(), cell:get_y()
	local result_list = {}
	local result_matrix = {}
	result_list[0] = cell
	for y = -dist, dist do
		result_matrix[y] = {}
		local new_y = cell_y + y
		if new_y >= 0 and new_y < self.data.size.y then
			for x = -dist, dist do
				local new_x = cell_x + x
				if new_x >= 0 and new_x < self.data.size.x then
					cell = native_raycasting.cells_get_by_coords(new_x, new_y)
					if (x ~= 0 or y ~= 0) then table_insert(result_list, cell) end
					result_matrix[y][x] = cell
				end
			end
		end
	end
	return result_list, result_matrix
end

---@return LevelDataWallBlock
function Level:map_get_wall_by_id(id)
	--assert(self:map_cell_id_in(id), "id:" .. id)
	return assert(self.data.walls[id])
end

---@return LevelDataWallBlock
function Level:map_get_wall_unsafe_by_id(id)
	return self.data.walls[id]
end

---@return LevelDataWallBlock
function Level:map_get_wall_by_coords(x, y)
	return self:map_get_wall_by_id(self:coords_to_id(x, y))
end

function Level:map_cell_id_in(id)
	return id >= 0 and id <= self.cell_max_id
end

function Level:coords_valid(x, y)
	return x >= 0 and y >= 0 and x < self.data.size.x and y < self.data.size.y
end

function Level:coords_to_id(x, y)
	return MAP_HELPER.coords_to_id(self.data, math.floor(x), math.floor(y))
end

--endregion


---@return LevelMapTile
function Level:get_tile(id)
	return assert(TILESET.by_id[id], "no tile with id:" .. id)
end

---@return LevelMapTile
function Level:get_tile_for_tileset(tileset_name, id)
	assert(tileset_name)
	assert(id)
	local tileset = assert(TILESET.tilesets[tileset_name], "no tileset with name:" .. tileset_name)
	local tile_id = tileset.first_gid + id
	assert(tile_id <= tileset.end_gid, "no tile:" .. tile_id .. " in tileset:" .. tileset_name .. " end:" .. tileset.end_gid)
	return self:get_tile(tile_id), tile_id
end

return Level