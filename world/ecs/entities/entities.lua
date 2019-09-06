local COMMON = require "libs.common"
local AI = require "world.ai.ai"
local WeaponPrototypes = require "world.weapons.weapon_prototypes"
local Weapon = require "world.weapons.weapon_base"
local EntityRenderObject = require "scenes.game.view.render_objects.entity_render_object"
local DoorRenderObject = require "scenes.game.view.render_objects.door_render_object"
local TAG = "ENTITIES"

local FACTORY = require "scenes.game.factories"

---@class FlashInfo
---@field current_time number
---@field total_time number

---@class DamageInfo
---@field source_e Entity
---@field target_e Entity
---@field raycast table|nil
---@field weapon_prototype WeaponPrototype

---@class HitInfo
---@field source_e Entity
---@field target_e Entity|nil
---@field raycast table|nil
---@field weapon_prototype WeaponPrototype

---@class InputInfo
---@field action_id hash
---@field action table

---@class PhysicsInfo
---@field message_id hash
---@field physics_message table
---@field physics_source hash

---@class CameraBobInfo
---@field value number
---@field speed number
---@field height number
---@field offset number
---@field offset_weapon number


---@class PlayerInventory
---@field keys table


---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if it player entity
---@field enemy boolean
---@field door boolean
---@field inventory PlayerInventory
---@field position vector3
---@field movement_velocity vector3
---@field movement_direction vector3
---@field movement_max_speed number
---@field movement_accel number
---@field movement_deaccel number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field url_collision_damage url collision always look at player
---@field url_collision_action action zone open door and etc
---@field url_go nil|url need update entity when changed or url_to_entity will be broken
---@field url_sprite url
---@field input_info InputInfo used for player input
---@field input_direction vector4 up down left right. Used for player input
---@field physics_info PhysicsInfo
---@field physics_obstacles_correction vector3
---@field damage_info DamageInfo
---@field hit_info HitInfo
---@field rotation_look_at_player boolean
---@field rotation_global boolean for pickups they use one global angle
---@field culling boolean objects that need culling like walls
---@field culling_empty_go boolean only if use empty go. Object will be deleted when not visible.
---For example pickups use go with collider. Sprite go will be destroyed if not visible
---but collider will be on the scene
---@field dynamic_color boolean update color by sprite.set_constant instead of position in shader
---@field tile LevelDataTile need for draw objects
---@field drawing boolean entity is visible in current frame.
---@field ai AI
---@field camera_bob_info CameraBobInfo
---@field weapons Weapon[] map.key is number.For user 1-pistol,5-shotgun and etc.
---@field weapon_current_idx number
---@field ammo table
---@field hp number
---@field pickuped boolean pickup already get. Need because can have multiple responses
---@field flash_info FlashInfo flash sprite when take damage
---@field auto_destroy boolean if true will be destroyed
---@field auto_destroy_delay number when auto_destroy false and delay nil or 0 then destroy entity
---@field render_object RenderObject


---@class ENTITIES
local Entities = {}

---@type Entity[]
Entities.url_to_entity = {}
Entities.entity_to_url = {}
Entities.enemies = {}

--region utils
---@param url url key that used for mapping entity to url_go
local function url_to_key(url) return url.path end

---@param ignore_warning boolean Used when trying to find entity when hit wall.
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

---@param game_controller GameController
function Entities.set_game_controller(game_controller) Entities.game_controller = assert(game_controller) end

--region ecs callbacks
---@param e Entity
function Entities.on_entity_removed(e)
	if e.url_go then
		Entities.url_to_entity[url_to_key(e.url_go)] = nil
		Entities.entity_to_url[e] = nil
	end
	if e.url_collision_damage then
		Entities.url_to_entity[url_to_key(e.url_collision_damage)] = nil
	end
	if e.url_collision_action then
		Entities.url_to_entity[url_to_key(e.url_collision_action)] = nil
	end
	--TODO fix performance
	if e.enemy then
		local idx = assert(COMMON.LUME.find(Entities.enemies,e),"unknown enemy")
		table.remove(Entities.enemies,idx)
	end

	if e.render_object and e.render_object.url_root then
		e.render_object:dispose()
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
	if e.url_collision_damage then
		Entities.url_to_entity[url_to_key(e.url_collision_damage)] = e
	end
	if e.url_collision_action then
		Entities.url_to_entity[url_to_key(e.url_collision_action)] = e
	end
	--TODO
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
		if e.url_collision_damage then
			Entities.url_to_entity[url_to_key(e.url_collision_damage)] = e
		end
		if e.url_collision_action then
			Entities.url_to_entity[url_to_key(e.url_collision_action)] = e
		end
	end
end
--endregion


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
	e.movement_velocity = vmath.vector3(0,0,0)
	e.movement_direction = vmath.vector3(0,0,0)
	e.movement_max_speed = 4
	e.movement_accel = 2
	e.movement_deaccel = 4
	e.player = true
	e.inventory = {
		keys = {}
	}
	e.url_go =   msg.url("/player")
	e.camera_bob_info = {
		value = 0,
		height = 0.023,
		speed = 14,
		offset = 0,
		offset_weapon = 0,
	}
	e.hp = 100
	e.ammo = {
		[WeaponPrototypes.AMMO_TYPES.PISTOL] = 20,
		[WeaponPrototypes.AMMO_TYPES.CHAINGUN] = 20000
	}
	e.weapons = {
		Weapon(WeaponPrototypes.prototypes.PISTOL,e,Entities.game_controller),
		Weapon(WeaponPrototypes.prototypes.CHAINGUN,e,Entities.game_controller)
	}
	--e.weapons[1]:equip()
	e.weapons[2]:equip()
	e.weapon_current_idx = 2
	e.url_collision_damage =  msg.url("/player/collision_damage")
	return e
end

--region enemies
---@return Entity
function Entities.create_enemy(position,factory)
	assert(position)
	assert(factory)
	local e = {}
	e.position= position
	e.angle = vmath.vector3(0,0,0)
	e.movement_velocity = vmath.vector3(0,0,0)
	e.movement_direction = vmath.vector3(0,0,0)
	e.movement_accel = 3
	e.movement_deaccel = 6
	e.movement_max_speed = 1 + math.random()*0.25
	e.enemy = true
	local urls = collectionfactory.create(factory,vmath.vector3(e.position.x,0.5,-e.position.z),vmath.quat_rotation_z(0),nil)
	e.url_go = msg.url(urls[FACTORY.OBJECT_HASHES.root])
	e.url_sprite = msg.url(urls[FACTORY.OBJECT_HASHES.sprite])
	e.url_collision_damage = msg.url(urls[FACTORY.OBJECT_HASHES.collision_damage])
	e.url_sprite.fragment = FACTORY.COMPONENT_HASHES.sprite
	e.rotation_look_at_player = true
	e.dynamic_color = true
	return e
end

---@param object LevelDataObject
---@return Entity
function Entities.create_blob_from_object(object)
	assert(object)
	return Entities.create_blob(vmath.vector3(object.cell_xf, object.cell_yf,0))
end

---@return Entity
function Entities.create_blob(pos)
	local e = Entities.create_enemy(assert(pos),FACTORY.FACTORY_COLLECTION.enemy_blob)
	e.ai = AI.Blob(e,Entities.game_controller)
	e.hp = 20
	e.weapons = {Weapon(WeaponPrototypes.prototypes.ENEMY_MELEE,e,Entities.game_controller)}
	e.weapons[1]:equip()
	e.weapon_current_idx = 1
	return e
end

---@return Entity
function Entities.create_spawner_enemy(object)
	local e = {}
	e.ai = AI.SpawnerEnemy(e,Entities.game_controller,object)
	return e
end
--endregion

--region draw object
---@return Entity
function Entities.create_draw_object_base(pos)
	local e = {}
	e.position= assert(pos)
	e.culling = true
	e.dynamic_color = true
	return e
end

---@param object LevelDataObject
---@return Entity
function Entities.create_draw_object_from_tiled(object)
	if object.properties.culling then
		local e = Entities.create_draw_object_base(vmath.vector3(object.cell_xf, object.cell_yf, 0))
		e.tile = Entities.game_controller.level:get_tile(object.tile_id)
		if object.properties.look_at_player then e.rotation_look_at_player = true end
		if object.properties.global_rotation then e.rotation_global = true end
		return e
	end
end
--endregion

---@param object LevelDataObject
------@return Entity
function Entities.create_pickup_from_object(object)
	return Entities.create_pickup(vmath.vector3(object.cell_xf, object.cell_yf,0),object.tile_id)
end
---@return Entity
function Entities.create_pickup(pos,tile_id)
	local e = {}
	e.tile = Entities.game_controller.level:get_tile(tile_id)
	e.position= pos
	local url = factory.create(FACTORY.FACTORY.pickup,vmath.vector3(e.position.x,0.5,e.position.y),vmath.quat_rotation_z(0),nil)
	e.url_go = msg.url(url)
	if e.tile.properties.look_at_player then e.rotation_look_at_player = true end
	if e.tile.properties.global_rotation then e.rotation_global = true end
	e.culling = true
	e.culling_empty_go = false
	e.dynamic_color = true
	return e
end


--region entities utils
---@return Entity
function Entities.create_input(action_id,action)
	return {input_info = {action_id = action_id, action = action },auto_destroy = true}
end

---@return Entity
function Entities.create_physics(message_id,message,source)
	return {physics_info = {message_id = assert(message_id),message = assert(message),source = assert(source)}, auto_destroy = true}
end

function Entities.create_raycast_damage_info(source_e,target_e,weapon_prototype,raycast)
	local e = {}
	e.damage_info = {
		source_e = assert(source_e),
		target_e = assert(target_e),
		raycast = raycast,
		weapon_prototype = assert(weapon_prototype)
	}
	return e
end

function Entities.create_hit_info(source_e,target_e,weapon_prototype,raycast)
	local e = {}
	e.hit_info = {
		source_e = assert(source_e),
		target_e = target_e,
		raycast = raycast,
		weapon_prototype = assert(weapon_prototype)
	}
	return e
end

function Entities.create_flash_info(total_time,entity)
	if not entity.flash_info then
		entity.flash_info = {}
		Entities.game_controller.level.ecs_world:add_entity(entity)
	end
	entity.flash_info.total_time = total_time
	entity.flash_info.current_time = 0
end

---@param object LevelDataObject
---@return Entity
function Entities.create_door(object)
	---@type Entity
	local e = {}
	e.culling = true
	e.position = vmath.vector3(object.cell_xf,object.cell_yf,0.5)
	e.tile = Entities.game_controller.level:get_tile(object.tile_id)
	assert(e.tile.properties.door)
	local urls = collectionfactory.create(FACTORY.FACTORY_COLLECTION.door,nil, vmath.quat_rotation_z(0),nil)
	e.url_go = assert(msg.url(urls[FACTORY.OBJECT_HASHES.root]))
	e.url_collision_action = assert(msg.url(urls[FACTORY.OBJECT_HASHES.action_collider]))
	e.render_object = DoorRenderObject({position = e.position, e = e, })
	e.render_object:create()
	e.door = true
	return e
end

---@return Entity
function Entities.create(name,...)
	assert(name)
	local f = Entities["create_" .. name]
	if not f then
		COMMON.e("unknown entity:" .. tostring(name),TAG)
	else
		return f(...)
	end
end

function Entities.create_from_object(name,object,...)
	assert(name)
	assert(object)
	local f = Entities["create_" .. name .. "_from_object"]
	if not f then
		COMMON.e("unknown entity:" .. tostring(name),TAG)
	else
		return f(object,...)
	end
end
--endregion

--endregion

return Entities




