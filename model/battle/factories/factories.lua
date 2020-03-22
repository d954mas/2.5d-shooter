local COMMON = require "libs.common"
local TILESET = require "model.battle.level.tileset"
local URLS = {
	factory = {
		ceil = msg.url("game_scene:/factories#ceil"),
		floor = msg.url("game_scene:/factories#floor"),
		empty = msg.url("game_scene:/factories#empty"),
		wall_part = msg.url("game_scene:/factories#wall_part"),
		debug_physics_body_static = msg.url("game_scene:/factories#debug_physics_body_static"),
		debug_physics_body_dynamic = msg.url("game_scene:/factories#debug_physics_body_dynamic"),
		wall_part = msg.url("game_scene:/factories#wall_part")
	}
}

---@class FloorGO
---@field root url
---@field sprite url


---@class WallGoSprites
---@field root url
---@field north url
---@field south url
---@field east url
---@field west url

---@class WallGo
---@field root url
---@field base WallGoSprites
---@field transparent WallGoSprites|nil transparent have two sprites for every side.Need it for correct understand light color


---@class DebugPhysicsBodyGo
---@field root url

local M = {}

---@return FloorGO
function M.create_floor(position, tile_id)
	local tile = TILESET.by_id[tile_id]
	local floor = msg.url(factory.create(URLS.factory.floor, position, nil, nil, tile.scale))
	local sprite_url = msg.url(floor.socket, floor.path, COMMON.HASHES.SPRITE)
	sprite.play_flipbook(sprite_url, tile.image_hash)
	return { root = floor, sprite = sprite_url }
end

---@return FloorGO
function M.create_ceil(position, tile_id)
	local tile = TILESET.by_id[tile_id]
	local ceil = msg.url(factory.create(URLS.factory.ceil, position, nil, nil, tile.scale))
	local sprite_url = msg.url(ceil.socket, ceil.path, "sprite")
	sprite.play_flipbook(sprite_url, tile.image_hash)
	return { root = ceil, sprite = sprite_url }
end

local WALL_SIDE_CONFIGS = {
	north = {
		rotation = vmath.quat_rotation_y(math.rad(180)),
		position = vmath.vector3(0, 0, -0.5)
	},
	south = {
		rotation = vmath.quat_rotation_y(math.rad(0)),
		position = vmath.vector3(0, 0, 0.5)
	},
	east = {
		rotation = vmath.quat_rotation_y(math.rad(90)),
		position = vmath.vector3(0.5, 0, 0)
	},
	west = {
		rotation = vmath.quat_rotation_y(math.rad(90)),
		position = vmath.vector3(-0.5, 0, 0)
	},
}
local wall_sides = {
	"north", "south", "east", "west"
}

---@param wall LevelDataWallBlock
---@return WallGoSprites
local function create_wall_sprites(wall)
	local result = { root = msg.url(factory.create(URLS.factory.empty)) }
	for _, side in ipairs(wall_sides) do
		local tile_id = wall[side] or wall.base
		local tile = TILESET.by_id[tile_id]
		local wall_config = WALL_SIDE_CONFIGS[side]
		local sprite_go = msg.url(factory.create(URLS.factory.wall_part, wall_config.position, wall_config.rotation, nil, tile.scale))
		sprite_go.fragment = COMMON.HASHES.SPRITE
		sprite.play_flipbook(sprite_go, tile.image_hash)
		go.set_parent(sprite_go, result.root)
		result[side] = sprite_go
	end
	return result
end

---@return WallGo
---@param wall LevelDataWallBlock
function M.create_wall(position, wall)
	local root = msg.url(factory.create(URLS.factory.empty, position))
	local base = create_wall_sprites(wall)
	go.set_scale(1.0001, base.root)
	go.set_parent(base.root, root)
	return { root = root, base = base }
end

---@param physics NativePhysicsRectBody
function M.create_debug_physics_body(physics)
	local x, y, z = physics:get_position()
	local w, h, l = physics:get_size()
	local root = msg.url(factory.create(physics:is_static() and URLS.factory.debug_physics_body_static or URLS.factory.debug_physics_body_dynamic,
			vmath.vector3(x, z, -y), nil, nil, vmath.vector3(w / 64, l / 64, h / 64)*1.001))
	return { root = root }
end

return M