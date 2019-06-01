local COMMON = require "libs.common"
local require_f = require
local WORLD
---@class Entity
---@field tag string tag used for help when debug
---@field pos vector3
---@field rotation vector4 quaternion
---@field go_url nil|url

local Entities = {}


---@param pos vector3
---@return Entity
function Entities.create_player(pos)
	local e = {}
	e.tag = "player"
	e.pos = assert(pos)
	return e
end

---@param e Entity
function Entities.destroy_entity(e)

end










return Entities




