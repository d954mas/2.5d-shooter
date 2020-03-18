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
---@field cell_id number
---@field door boolean
---@field visible boolean
---@field inventory PlayerInventory
---@field position vector3
---@field movement_velocity vector3
---@field movement_direction vector3
---@field movement_max_speed number
---@field movement_accel number
---@field movement_deaccel number
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field url_go nil|url need update entity when changed or url_to_entity will be broken
---@field url_sprite url
---@field input_info InputInfo used for player input
---@field input_direction vector4 up down left right. Used for player input
---@field rotation_look_at_player boolean
---@field rotation_global boolean for pickups they use one global angle
---@field culling boolean objects that need culling like walls
---@field dynamic_color boolean update color by sprite.set_constant instead of position in shader
---@field drawing boolean entity is visible in current frame.
---@field camera_bob_info CameraBobInfo
---@field hp number
---@field auto_destroy boolean if true will be destroyed
---@field auto_destroy_delay number when auto_destroy false and delay nil or 0 then destroy entity



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
	local e = {}
	e.tag = "player"
	e.position = vmath.vector3(pos.x, pos.y, pos.z)
	e.angle = vmath.vector3(0, 0, 0)
	e.input_direction = vmath.vector4(0, 0, 0, 0)
	e.movement_velocity = vmath.vector3(0, 0, 0)
	e.movement_direction = vmath.vector3(0, 0, 0)
	e.movement_max_speed = 4
	e.movement_accel = 2
	e.movement_deaccel = 4
	e.player = true
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
	e.visible = false
	e.cell_id = cell_id
	e.floor = true
	e.wall_cell = self.level:map_get_wall_by_id(cell_id)
	e.floor_cell = assert(self.level.data.floor[cell_id])
	local x,y = e.wall_cell.native_cell:get_x()+0.5, e.wall_cell.native_cell:get_y() + 0.5
	e.position = vmath.vector3(x,y,0)
	return e
end

---@param cell_id number
function Entities:create_ceil(cell_id)
	assert(type(cell_id) == "number")
	---@type Entity
	local e = {}
	e.visible = false
	e.cell_id = cell_id
	e.ceil = true
	e.wall_cell = self.level:map_get_wall_by_id(cell_id)
	e.floor_cell = assert(self.level.data.floor[cell_id])
	local x,y = e.wall_cell.native_cell:get_x()+0.5, e.wall_cell.native_cell:get_y() + 0.5
	e.position = vmath.vector3(x,y,1)
	return e
end

return Entities




