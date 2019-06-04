local COMMON = require "libs.common"
local require_f = require
local WORLD
---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if player entity
---@field pos vector3
---@field direction vector4 up down left right
---@field velocity vector3
---@field speed number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field rotation vector4 quaternion
---@field go_url nil|url
---@field input boolean used for player input
---@field input_action_id hash used for player input
---@field input_action table used for player input

local Entities = {}


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
	return e
end


function Entities.create_input(action_id,action)
	return {input = true,input_action_id = action_id,input_action = action}
end

---@param e Entity
function Entities.destroy_entity(e)

end










return Entities




