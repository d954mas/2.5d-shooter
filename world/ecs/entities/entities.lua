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

local Entities = {}

Entities.url_to_entity = {}

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

---@param url url key that used for mapping entity to go_url
local function url_to_key(url)
	return url.path
end

function Entities.create_physics(message_id,message,source)
	local e = {}
	e.physics = true
	e.physics_message_id = assert(message_id)
	e.physics_message = assert(message)
	e.physics_source = assert(source)
	return e
end

function Entities.get_entity_for_url(url)
	local e =  Entities.url_to_entity[url_to_key(url)]
	if not e then 
		COMMON.w("no entity for url:" .. url,TAG) 
	end
	return e
end

function Entities.clear() end


---@param e Entity
function Entities.on_entity_removed(e)
	if e.go_url then Entities.url_to_entity[url_to_key(e.go_url)] = nil end
end

---@param e Entity
function Entities.on_entity_added(e)
	if e.go_url then Entities.url_to_entity[url_to_key(e.go_url)] = e end
end

---@param e Entity
function Entities.on_entity_updated(e)
	if e.go_url then Entities.url_to_entity[url_to_key(e.go_url)] = e end
end

function Entities.create_input(action_id,action)
	return {input = true,input_action_id = action_id,input_action = action}
end
return Entities




