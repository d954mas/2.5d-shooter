local COMMON = require "libs.common"

---@type LevelTilesets
local TILESET

local function TILESET_LOAD()
	if TILESET == nil then
		TILESET = json.decode(assert(sys.load_resource("/assets/levels/result/tileset.json"), "no tileset"))
		for k, v in pairs(TILESET.by_id) do
			if v.image then v.image_hash = hash(v.image) end
		end
	end
end

--Cell used in cpp and in lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0
local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")

---@param data LevelData
function Level:initialize(data)
	TILESET_LOAD()
	self.data = assert(data)
end

--region MAP
function Level:map_get_width() return self.data.size.x end
function Level:map_get_height() return self.data.size.y end

function Level:map_cell_in(x, y)
	return x >= 1 and x <= self:map_get_width() and y >= 1 and y <= self:map_get_height()
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