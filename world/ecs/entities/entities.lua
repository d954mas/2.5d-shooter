local COMMON = require "libs.common"
local require_f = require
local TAG = "ENTITIES"
---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if player entity
---@field pos vector3
---@field direction vector4 up down left right
---@field velocity vector3
---@field speed number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field rotation vector4 quaternion
---@field go_url nil|url Do not use different urls for same entity or url_to_entity will be broken
---@field input boolean used for player input
---@field input_action_id hash used for player input
---@field input_action table used for player input
---@field physics boolean
---@field physics_message_id hash
---@field physics_message table
---@field physics_source hash
---@field physics_obstacles_correction vector3
---@field hp number
---@field rotate_to_hero boolean
---@field rotate_to_global boolean for pickups they use one global angle
---@field need_draw boolean objects that can be draw
---@field sprite_url url need for draw
---@field tile_id number need for draw objects
---@field drawing boolean this frame visible entities

local Entities = {}

Entities.url_to_entity = {}
Entities.entity_to_url = {}

--region utils
---@param url url key that used for mapping entity to go_url
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
	if e.go_url then
		Entities.url_to_entity[url_to_key(e.go_url)] = nil
		Entities.entity_to_url[e] = nil
	end
end

---@param e Entity
function Entities.on_entity_added(e)
	if e.go_url then
		Entities.url_to_entity[url_to_key(e.go_url)] = e
		Entities.entity_to_url[e] = e.go_url
	end
end

---@param e Entity
function Entities.on_entity_updated(e)
	local prev_url = Entities.entity_to_url[e] and url_to_key(Entities.entity_to_url[e])
	local new_url = e.go_url and url_to_key(e.go_url)
	if prev_url ~= e.go_url then
		---COMMON.i(string.format("url changed:%s to %s",prev_url,new_url))
		if prev_url then Entities.url_to_entity[prev_url] = e end
		if new_url then Entities.url_to_entity[new_url] = e end
		Entities.entity_to_url[e] = e.go_url
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
	e.go_url =   msg.url("/player")
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
function Entities.create_draw_object(pos)
	local e = {}
	e.pos = assert(pos)
	e.need_draw = true
	return e
end
---@return Entity
function Entities.create_input(action_id,action)
	return {input = true,input_action_id = action_id,input_action = action }
end
return Entities




