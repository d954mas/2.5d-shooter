local COMMON = require "libs.common"
local require_f = require
local TAG = "ENTITIES"
---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if player entity
---@field pos vector3
---@field pos_translate vector3 additional movement for pos. If go need bottom or top align
---@field direction vector4 up down left right
---@field velocity vector3
---@field speed number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field url_go nil|url Do not use different urls for same entity or url_to_entity will be broken
---@field url_sprite url need for draw
---@field input boolean used for player input
---@field input_action_id hash used for player input
---@field input_action table used for player input
---@field physics boolean
---@field physics_message_id hash
---@field physics_message table
---@field physics_source hash
---@field physics_obstacles_correction vector3
---@field hp number
---@field look_at_player boolean
---@field global_rotation boolean for pickups they use one global angle
---@field need_draw boolean objects that can be draw
---@field draw_always boolean that object draw always. Used for enemies because of animations
---@field render_dynamic_color boolean

---@field tile_id number need for draw objects
---@field drawing boolean this frame visible entities
---@field cell_data NativeCellData
---@field enemy boolean

local HASH_SPRITE = hash("sprite")
local OBJECT_HASHES = {
	root = hash("/root"),
	sprite = hash("/sprite")
}

local FACTORY_ENEMY_BLOB_URL = msg.url("game:/factories#factory_enemy_blob")

local Entities = {}

Entities.url_to_entity = {}
Entities.entity_to_url = {}

--region utils
---@param url url key that used for mapping entity to url_go
local function url_to_key(url)
	return url.path
end

function Entities.get_entity_for_url(url)
	local e =  Entities.url_to_entity[url_to_key(url)]
	if not e then
		COMMON.w("no entity for url:" .. url,TAG)
	end
	return e
end

function Entities.clear()
	Entities.entity_to_url = {}
	Entities.url_to_entity = {}
end


---@param e Entity
function Entities.on_entity_removed(e)
	if e.url_go then
		Entities.url_to_entity[url_to_key(e.url_go)] = nil
		Entities.entity_to_url[e] = nil
	end
end

---@param e Entity
function Entities.on_entity_added(e)
	if e.url_go then
		Entities.url_to_entity[url_to_key(e.url_go)] = e
		Entities.entity_to_url[e] = e.url_go
	end
end

---@param e Entity
function Entities.on_entity_updated(e)
	local prev_url = Entities.entity_to_url[e] and url_to_key(Entities.entity_to_url[e])
	local new_url = e.url_go and url_to_key(e.url_go)
	if prev_url ~= e.url_go then
		---COMMON.i(string.format("url changed:%s to %s",prev_url,new_url))
		if prev_url then Entities.url_to_entity[prev_url] = e end
		if new_url then Entities.url_to_entity[new_url] = e end
		Entities.entity_to_url[e] = e.url_go
	end
end
--endregion

--region Entities

---@param pos vector3
---@return Entity
function Entities.create_player(pos)
	local e = {}
	e.tag = "player"
	e.pos = assert(pos)
	e.angle = vmath.vector3(0,0,0)
	e.direction = vmath.vector4(0,0,0,0) 
	e.velocity = vmath.vector3(0,0,0)
	e.speed = 4
	e.player = true
	e.url_go =   msg.url("/player")
	return e
end
---@return Entity
function Entities.create_physics(message_id,message,source)
	local e = {}
	e.physics = true
	e.physics_message_id = assert(message_id)
	e.physics_message = assert(message)
	e.physics_source = assert(source)
	return e
end
---@return Entity
function Entities.create_draw_object_base(pos)
	local e = {}
	e.pos = assert(pos)
	e.need_draw = true
	return e
end

function Entities.create_enemy(pos,factory)
	local e = {}
	e.pos = assert(pos)
	e.angle = vmath.vector3(0,0,0)
	e.direction = vmath.vector4(0,0,0,0)
	e.velocity = vmath.vector3(0,0,0)
	e.speed = 4
	e.enemy = true
	local urls = collectionfactory.create(factory,vmath.vector3(e.pos.x,0.5,-e.pos.z+0.5),vmath.quat_rotation_z(0),nil)
	e.url_go = msg.url(urls[OBJECT_HASHES.root])
	e.url_sprite = msg.url(urls[OBJECT_HASHES.sprite])
	e.url_sprite.fragment = HASH_SPRITE
	e.look_at_player = true
	e.render_dynamic_color = true
	return e
end

function Entities.create_blob(pos)
	return Entities.create_enemy(pos,FACTORY_ENEMY_BLOB_URL)
end

---@return Entity
function Entities.create_floor(pos)
	return Entities.create_draw_object_base(pos)
end


---@return Entity
function Entities.create_object_from_tiled(object)
	if object.properties.draw then
		local e = Entities.create_draw_object_base(vmath.vector3(object.cell_xf-0.5, object.cell_yf - 0.5, 0))
		e.tile_id = object.tile_id
		if object.properties.look_at_player then
			e.look_at_player = true
		end
		if object.properties.global_rotation then
			e.global_rotation = true
		end
		return e
	end
end

---@return Entity
function Entities.create_input(action_id,action)
	return {input = true,input_action_id = action_id,input_action = action }
end
return Entities




