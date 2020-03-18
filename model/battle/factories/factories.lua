local COMMON = require "libs.common"
local TILESET = require "model.battle.level.tileset"
local URLS = {
	factory = {
		ceil = msg.url("game_scene:/factories#ceil"),
		floor = msg.url("game_scene:/factories#ceil")
	}
}

---@class FloorGO
---@field root url
---@field sprite url

local M = {}

---@return FloorGO
function M.create_floor(position, tile_id)
	local tile = TILESET.by_id[tile_id]
	local floor = msg.url(factory.create(URLS.factory.floor, position,nil,nil,tile.scale))
	local sprite_url = msg.url(floor.socket, floor.path, "sprite")
	sprite.play_flipbook(sprite_url, tile.image_hash)
	return { root = floor, sprite = sprite_url }
end

---@return FloorGO
function M.create_ceil(position, tile_id)
	local tile = TILESET.by_id[tile_id]
	local ceil =  msg.url(factory.create(URLS.factory.ceil, position,nil,nil,tile.scale))
	local sprite_url = msg.url(ceil.socket, ceil.path, "sprite")
	sprite.play_flipbook(sprite_url, tile.image_hash)
	return { root = ceil, sprite = sprite_url }
end

return M