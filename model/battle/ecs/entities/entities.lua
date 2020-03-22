local COMMON = require "libs.common"
local TAG = "Entities"

---@class FlashInfo
---@field current_time number
---@field total_time number


---@class InputInfo
---@field action_id hash
---@field action table

---@class CameraBobInfo
---@field value number
---@field speed number
---@field height number
---@field offset number
---@field offset_weapon number

---@class EntityMovement
---@field velocity vector3
---@field direction vector3
---@field max_speed number
---@field accel number
---@field deaccel number


---@class PlayerInventory
---@field keys table


---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if it player entity
---@field enemy boolean
---@field floor boolean
---@field ceil boolean
---@field wall boolean
---@field floor_cell LevelDataCellFloor
---@field wall_cell LevelDataWallBlock
---@field ceil_cell LevelDataCellFloor
---@field floor_go FloorGO
---@field ceil_go FloorGO
---@field wall_go WallGo
---@field cell_id number
---@field visible boolean
---@field position vector3
---@field movement EntityMovement
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field input_info InputInfo used for player input
---@field input_direction vector4 up down left right. Used for player input
---@field rotation_look_at_player boolean
---@field rotation_global boolean for pickups they use one global angle
---@field camera_bob_info CameraBobInfo
---@field auto_destroy boolean if true will be destroyed
---@field auto_destroy_delay number when auto_destroy false and delay nil or 0 then destroy entity
---@field url_go nil|url
---@field physics_body NativePhysicsRectBody
---@field physics_static boolean|nil static bodies can't move.
---@field physics_dynamic boolean|nil dynamic bodies update their positions




---@class ENTITIES
local Entities = COMMON.class("Entities")

function Entities:initialize()

end
---@param world World
function Entities:set_world(world)
	self.world = assert(world)
	self.battle_model = assert(world.battle_model)
	self.level = assert(world.battle_model.level)
	self.ecs = assert(world.battle_model.ecs)
end

--region ecs callbacks
---@param e Entity
function Entities:on_entity_removed(e)
	if e.physics_body then
		physics3d.destroy_rect(e.physics_body)
	end
end

---@param e Entity
function Entities:on_entity_added(e)
end

---@param e Entity
function Entities:on_entity_updated(e)
end

--endregion


--region Entities

---@param pos vector3
---@return Entity
function Entities:create_player(pos)
	assert(pos)
	---@type Entity
	local e = {}
	e.tag = "player"
	e.position = vmath.vector3(pos.x, pos.y, pos.z)
	e.angle = vmath.vector3(0, 0, 0)
	e.input_direction = vmath.vector4(0, 0, 0, 0)
	e.movement = {
		velocity = vmath.vector3(0, 0, 0),
		direction = vmath.vector3(0, 0, 0),
		max_speed = 4,
		accel = 2,
		deaccel = 4
	}
	e.player = true
	e.physics_body = physics3d.create_rect(e.position.x, e.position.y, e.position.z, 1, 1, 1, false)
	e.physics_dynamic = true
	e.url_go = msg.url("/player")
	e.camera_bob_info = {
		value = 0,
		height = 0.023,
		speed = 14,
		offset = 0,
		offset_weapon = 0,
	}
	e.hp = 100
	return e
end

---@param cell_id number
function Entities:create_floor(cell_id)
	assert(type(cell_id) == "number")
	---@type Entity
	local e = {}
	e.cell_id = cell_id
	e.floor = true
	e.wall_cell = self.level:map_get_wall_by_id(cell_id)
	e.floor_cell = assert(self.level.data.floor[cell_id])
	local x, y = e.wall_cell.native_cell:get_x() + 0.5, e.wall_cell.native_cell:get_y() + 0.5
	e.position = vmath.vector3(x, y, 0)
	return e
end

---@param cell_id number
function Entities:create_ceil(cell_id)
	assert(type(cell_id) == "number")
	---@type Entity
	local e = {}
	e.cell_id = cell_id
	e.ceil = true
	e.wall_cell = self.level:map_get_wall_by_id(cell_id)
	e.ceil_cell = assert(self.level.data.ceil[cell_id])
	local x, y = e.wall_cell.native_cell:get_x() + 0.5, e.wall_cell.native_cell:get_y() + 0.5
	e.position = vmath.vector3(x, y, 1)
	return e
end

---@param cell_id number
function Entities:create_wall(cell_id)
	assert(type(cell_id) == "number")
	---@type Entity
	local e = {}
	e.cell_id = cell_id
	e.wall = true
	e.wall_cell = self.level:map_get_wall_by_id(cell_id)
	local x, y = e.wall_cell.native_cell:get_x() + 0.5, e.wall_cell.native_cell:get_y() + 0.5
	e.position = vmath.vector3(x, y, 0.5)

	if (e.wall_cell.native_cell:get_blocked()) then
		e.physics_body = physics3d.create_rect(e.position.x, e.position.y, e.position.z, 1, 1, 1, true)
		e.physics_static = true
	end
	return e
end

---@return Entity
function Entities:create_input(action_id, action)
	return { input_info = { action_id = action_id, action = action }, auto_destroy = true }
end

return Entities




