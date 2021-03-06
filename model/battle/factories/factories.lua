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
		wall_part_transparent = msg.url("game_scene:/factories#wall_part_transparent"),
		level_object = msg.url("game_scene:/factories#level_object"),
		pickup = msg.url("game_scene:/factories#pickup"),
		level_object_cup = msg.url("game_scene:/factories#level_object_cup"),
		level_object_human = msg.url("game_scene:/factories#level_object_human"),
		level_object_teapot = msg.url("game_scene:/factories#level_object_teapot"),
		light_debug = msg.url("game_scene:/factories#light_debug"),
		effect_sprite = msg.url("game_scene:/factories#effect_sprite")
	}
}

local HASH_NORTH = hash("north")
local HASH_SOUTH = hash("south")
local HASH_EAST = hash("east")
local HASH_WEST = hash("west")
local HASH_TOP = hash("top")
local HASH_BOTTOM = hash("bottom")

local OBJECTS_CONFIGS = {
	LEVEL_OBJECTS = {
		CUP = {
			scale = 0.1
		},
		TEAPOT = {
			scale = 0.05
		},
		HUMAN = {
			scale = 0.34
		}
	}
}

---@class FloorGO
---@field root url
---@field sprite url

---@class LevelObjectGO
---@field root url
---@field sprite url it have sprite or model
---@field model url

---@class PickupObjectGO
---@field root url
---@field sprite url it have sprite or model
---@field model url

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

---@class DebugLightGo
---@field root url
---@field east url
---@field west url
---@field south url
---@field north url
---@field top url
---@field bottom url

local M = {}

M.URLS = URLS

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

---@return LevelObjectGO
---@param map_object LevelMapObject
function M.create_level_object(position, map_object)
	local tag = map_object.properties.tag
	if (tag == "teapot") then
		return M.create_level_object_from_model(position, map_object, URLS.factory.level_object_teapot, OBJECTS_CONFIGS.LEVEL_OBJECTS.TEAPOT)
	elseif (tag == "human") then
		return M.create_level_object_from_model(position, map_object, URLS.factory.level_object_human, OBJECTS_CONFIGS.LEVEL_OBJECTS.HUMAN)
	elseif (tag == "cup") then
		return M.create_level_object_from_model(position, map_object, URLS.factory.level_object_cup, OBJECTS_CONFIGS.LEVEL_OBJECTS.CUP)
	else
		return M.create_draw_object_from_tile(URLS.factory.level_object, position, map_object.tile_id)
	end
end

---@return PickupObjectGO
---@param map_object LevelMapObject
function M.create_pickup(position, map_object)
	return M.create_draw_object_from_tile(URLS.factory.pickup, position, map_object.tile_id)
end

function M.create_level_object_from_model(position, map_object, factory_url, config)
	local root = msg.url(factory.create(factory_url, position, nil, nil, config.scale))
	local model_url = msg.url(root.socket, root.path, "sprite")
	return { root = root, model = model_url }
end

function M.create_draw_object_from_tile(factory_url, position, tile_id)
	assert(factory_url)
	assert(position)
	assert(tile_id)
	local tile = TILESET.by_id[tile_id]
	local root_empty = tile.properties.sprite_origin_y
	local root = msg.url(factory.create(root_empty and URLS.factory.empty or factory_url, position, nil, nil, tile.scale))
	local sprite_go = root
	if (root_empty) then
		sprite_go = msg.url(factory.create(factory_url))
		go.set_parent(sprite_go, root)
		go.set_position(vmath.vector3(0, tile.properties.sprite_origin_y, 0), sprite_go)
	end

	local sprite_url = msg.url(sprite_go.socket, sprite_go.path, "sprite")

	sprite.play_flipbook(sprite_url, tile.image_hash)
	return { root = root, sprite = sprite_url }
end

function M.create_draw_object_with_sprite(sprite_factory_url, position, sprite_hash, scale)
	assert(sprite_factory_url)
	assert(position)
	assert(sprite)
	local root = msg.url(factory.create(URLS.factory.empty, position, nil, nil, scale))
	local sprite_go = root
	sprite_go = msg.url(factory.create(sprite_factory_url))
	go.set_parent(sprite_go, root)
	go.set_position(vmath.vector3(0, 0, 0), sprite_go)

	local sprite_url = msg.url(sprite_go.socket, sprite_go.path, COMMON.HASHES.hash("sprite"))

	sprite.play_flipbook(sprite_url, sprite_hash)
	return { root = root, sprite = sprite_url }
end

local WALL_SIDE_CONFIGS = {
	north = {
		rotation = vmath.quat_rotation_y(math.rad(0)),
		position = vmath.vector3(0, 0, -0.5)
	},
	south = {
		rotation = vmath.quat_rotation_y(math.rad(180)),
		position = vmath.vector3(0, 0, 0.5)
	},
	east = {
		rotation = vmath.quat_rotation_y(math.rad(-90)),
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
local function create_wall_sprites(wall, transparent)
	local result = { root = msg.url(factory.create(URLS.factory.empty)) }
	for _, side in ipairs(wall_sides) do
		local tile_data = (wall[side] or wall.base)
		local tile_id = tile_data.tile_id
		local tile = TILESET.by_id[tile_id]
		local wall_config = WALL_SIDE_CONFIGS[side]

		local rotation = vmath.quat(wall_config.rotation)
		local scale = vmath.vector3(tile.scale, tile.scale, tile.scale)
		scale.x = tile_data.fh and -scale.x or scale.x
		scale.y = tile_data.fv and -scale.y or scale.y
		--diagonal flip https://discourse.mapeditor.org/t/can-i-rotate-tiles/703/5
		if tile_data.fd then
			scale.x = -scale.x
			rotation = rotation * vmath.quat_rotation_z(math.rad(-90))
		end

		local sprite_go = msg.url(factory.create(transparent and URLS.factory.wall_part_transparent or URLS.factory.wall_part,
				wall_config.position, rotation, nil, scale))
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
	local base = create_wall_sprites(wall, wall.transparent)
	local transparent
	go.set_scale(1.0001, base.root)
	go.set_parent(base.root, root)
	if (wall.transparent) then
		transparent = create_wall_sprites(wall, wall.transparent)
		go.set_scale(0.999, transparent.root)
		go.set_parent(transparent.root, root)
	end
	return { root = root, base = base, transparent = transparent }
end

---@param physics NativePhysicsRectBody
---@return DebugPhysicsBodyGo
function M.create_debug_physics_body(physics)
	local x, y, z = physics:get_position()
	local w, h, l = physics:get_size()
	local f = URLS.factory
	local root = msg.url(factory.create(physics:is_static() and f.debug_physics_body_static or f.debug_physics_body_dynamic,
			vmath.vector3(x, z, -y), nil, nil, vmath.vector3(w / 64, l / 64, h / 64) * 1.001))
	return { root = root }
end

---@param e Entity
---@return DebugLightGo
function M.create_debug_light(e)
	assert(e.light)
	local root = msg.url(factory.create(URLS.factory.light_debug, vmath.vector3(e.position.x, e.position.z, -e.position.y), nil, nil,
			vmath.vector3(0.15 / 64, 0.15 / 64, 0.15 / 64)))
	return { root = root,
			 north = msg.url(root.socket, root.path, HASH_NORTH), south = msg.url(root.socket, root.path, HASH_SOUTH),
			 east = msg.url(root.socket, root.path, HASH_EAST), west = msg.url(root.socket, root.path, HASH_WEST),
			 top = msg.url(root.socket, root.path, HASH_TOP), bottom = msg.url(root.socket, root.path, HASH_BOTTOM)
	}
end

return M