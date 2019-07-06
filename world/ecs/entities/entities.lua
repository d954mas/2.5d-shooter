local COMMON = require "libs.common"
local AI = require "world.ai.ai"
local TAG = "ENTITIES"

---@class Ammo
---@field pistol number


---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if player entity
---@field enemy boolean
---@field spawner boolean
---@field position vector3
---@field velocity vector3
---@field speed number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field url_go nil|url need update entity when changed or url_to_entity will be broken
---@field url_sprite url
---@field input boolean used for player input
---@field input_action_id hash used for player input
---@field input_action table used for player input
---@field input_direction vector4 up down left right. Used for player input
---@field physics boolean
---@field physics_message_id hash
---@field physics_message table
---@field physics_source hash
---@field physics_obstacles_correction vector3
---@field rotation_look_at_player boolean
---@field rotation_global boolean for pickups they use one global angle
---@field culling boolean objects that need culling like walls
---@field draw_always boolean that object draw always. Used for enemies because of animations
---@field dynamic_color boolean
---@field tile_id number need for draw objects
---@field drawing boolean this frame visible entities
---@field cell_data NativeCellData
---@field ai AI
---@field camera_bob number
---@field camera_bob_speed number
---@field camera_bob_height number
---@field camera_bob_offset number
---@field weapon_bob_offset number
---@field weapon Entity
---@field ammo Ammo
---@field hp number
---@field pickuped boolean pickup already get. Need because can have multiple responses

local HASH_SPRITE = hash("sprite")
local OBJECT_HASHES = {
	root = hash("/root"),
	sprite = hash("/sprite"),
}

local FACTORY_ENEMY_BLOB_URL = msg.url("game:/factories#factory_enemy_blob")
local FACTORY_PICKUP_URL = msg.url("game:/factories#factory_pickup")

---@class ENTITIES
local Entities = {}

Entities.url_to_entity = {}
Entities.entity_to_url = {}
Entities.enemies = {}

--region utils
---@param url url key that used for mapping entity to url_go
local function url_to_key(url)
	return url.path
end

---@param ignore_warning boolean pickup can try get entity while go is already removed. Something with physics
function Entities.get_entity_for_url(url,ignore_warning)
	local e =  Entities.url_to_entity[url_to_key(url)]
	if not e and not ignore_warning then
		COMMON.w("no entity for url:" .. url,TAG)
	end
	return e
end

function Entities.clear()
	Entities.entity_to_url = {}
	Entities.url_to_entity = {}
	Entities.enemies = {}
end

---@param e Entity
function Entities.on_entity_removed(e)
	if e.url_go then
		Entities.url_to_entity[url_to_key(e.url_go)] = nil
		Entities.entity_to_url[e] = nil
	end
	--TODO fix performance
	if e.enemy then
		local idx = assert(COMMON.LUME.find(Entities.enemies,e),"unknown enemy")
		table.remove(Entities.enemies,idx)
	end

	if e.url_go then
		go.delete(e.url_go,true)
	end
end

---@param e Entity
function Entities.on_entity_added(e)
	if e.url_go then
		Entities.url_to_entity[url_to_key(e.url_go)] = e
		Entities.entity_to_url[e] = e.url_go
	end
	if e.enemy then
		local idx = COMMON.LUME.find(Entities.enemies,e)
		if not idx then
			Entities.enemies[#Entities.enemies+1] = e
		end
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

---@param game_controller GameController
function Entities.set_game_controller(game_controller)
	Entities.game_controller = assert(game_controller)
end

--endregion

--region Entities

---@param pos vector3
---@return Entity
function Entities.create_player(pos)
	local e = {}
	e.tag = "player"
	e.position= assert(pos)
	e.angle = vmath.vector3(0,0,0)
	e.input_direction = vmath.vector4(0,0,0,0)
	e.velocity = vmath.vector3(0,0,0)
	e.speed = 4
	e.player = true
	e.url_go =   msg.url("/player")
	e.camera_bob = 0
	e.camera_bob_height = 0.012
	e.camera_bob_speed = 4
	e.camera_bob_offset = 0
	e.hp = 100
	e.ammo = {
		pistol = 20
	}
	return e
end

---@return Entity
function Entities.create_draw_object_base(pos)
	local e = {}
	e.position= assert(pos)
	e.culling = true
	e.dynamic_color = true
	return e
end


--region enemies
function Entities.create_enemy(position,factory)
	assert(position)
	assert(factory)
	local e = {}
	e.position= position
	e.angle = vmath.vector3(0,0,0)
	e.velocity = vmath.vector3(0,0,0)
	e.speed = 0.9 + math.random()*0.25
	e.enemy = true
	local urls = collectionfactory.create(factory,vmath.vector3(e.position.x,0.5,-e.position.z+0.5),vmath.quat_rotation_z(0),nil)
	e.url_go = msg.url(urls[OBJECT_HASHES.root])
	e.url_sprite = msg.url(urls[OBJECT_HASHES.sprite])
	e.url_sprite.fragment = HASH_SPRITE
	e.rotation_look_at_player = true
	e.dynamic_color = true
	return e
end

function Entities.create_blob(pos,tile_object)
	pos = pos or vmath.vector3(tile_object.cell_xf + 0.5, tile_object.cell_yf+0.5,0)
	local e = Entities.create_enemy(pos,FACTORY_ENEMY_BLOB_URL)
	e.ai = AI.Blob(e,Entities.game_controller)
	return e
end
--endregion

--region spawners
function Entities.create_spawner_enemy(object)
	local e = {}
	e.spawner = true
	e.ai = AI.SpawnerEnemy(e,Entities.game_controller,object)
	return e
end

--endregion


---@return Entity
function Entities.create_floor(pos)
	return Entities.create_draw_object_base(pos)
end


---@return Entity
function Entities.create_object_from_tiled(object)
	if object.properties.culling then
		local e = Entities.create_draw_object_base(vmath.vector3(object.cell_xf-0.5, object.cell_yf - 0.5, 0))
		e.tile_id = object.tile_id
		if object.properties.look_at_player then
			e.rotation_look_at_player = true
		end
		if object.properties.global_rotation then
			e.rotation_global = true
		end
		return e
	end
end

function Entities.create_pickup(pos,tile_object)
	pos = pos or vmath.vector3(tile_object.cell_xf + 0.5, tile_object.cell_yf+0.5,0)
	local e = {}
	e.tile_id = tile_object.tile_id
	e.position= pos
	local url = factory.create(FACTORY_PICKUP_URL,vmath.vector3(e.position.x,0.5,e.position.y),vmath.quat_rotation_z(0),nil,1/128)
	e.url_go = msg.url(url)
	e.url_sprite = msg.url(url)
	e.url_sprite.fragment = HASH_SPRITE
	if tile_object.properties.look_at_player then
		e.rotation_look_at_player = true
	end
	if tile_object.properties.global_rotation then
		e.rotation_global = true
	end
	e.rotation_global = true
	local tile = assert(Entities.game_controller.level:get_tile(e.tile_id),"no tile with id" .. tostring(e.tile_id))
	sprite.play_flipbook(e.url_sprite,hash(tile.image))
	return e
end


--region entities utils
---@return Entity
function Entities.create_input(action_id,action)
	return {input = true,input_action_id = action_id,input_action = action }
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

function Entities.create(name,...)
	assert(name)
	local f = Entities["create_" .. name]
	if not f then
		COMMON.e("unknown entity:" .. tostring(name),TAG)
	else
		return f(...)
	end
end
--endregion

--endregion

return Entities




