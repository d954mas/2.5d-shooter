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

---@class LightParams
---@field start_light vector3 xyz h(0-360) s(0-1) v(0-1)
---@field light_power number decrease value per distance
---@field camera NativeCamera



---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if it player entity
---@field enemy boolean
---@field level_object boolean
---@field floor boolean
---@field ceil boolean
---@field wall boolean
---@field light boolean
---@field floor_cell LevelDataCellFloor
---@field wall_cell LevelDataWallBlock
---@field ceil_cell LevelDataCellFloor
---@field floor_go FloorGO
---@field ceil_go FloorGO
---@field wall_go WallGo
---@field level_object_go LevelObjectGO
---@field debug_physics_body_go WallGo
---@field debug_light_go DebugLightGo
---@field cell_id number
---@field visible boolean
---@field position vector3
---@field position_z_center number position.z = 0 mean that entity bottom is on floor. use this to get correct position_z_center
---@field movement EntityMovement
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field input_info InputInfo used for player input
---@field input_direction vector4 up down left right. Used for player input
---@field rotation_look_at_player boolean
---@field rotation_look_at_player_quaternion quaternion
---@field rotation_global boolean for pickups they use one global angle
---@field camera_bob_info CameraBobInfo
---@field auto_destroy boolean if true will be destroyed
---@field auto_destroy_delay number when auto_destroy false and delay nil or 0 then destroy entity
---@field root_go nil|url
---@field physics_body NativePhysicsRectBody base collision. Not rotated.
---@field physics_static boolean|nil static bodies can't move.
---@field physics_dynamic boolean|nil dynamic bodies update their positions
---@field physics_obstacles_correction vector3
---@field map_object LevelMapObject
---@field dynamic_color boolean
---@field light_params LightParams




---@class ENTITIES
local Entities = COMMON.class("Entities")

function Entities:initialize()
	self.masks = {
		PLAYER = bit.bor(physics3d.GROUPS.ENEMY, physics3d.GROUPS.OBSTACLE),
		WALL = bit.bor(physics3d.GROUPS.ENEMY, physics3d.GROUPS.PLAYER)
	}
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
	if (e.light_params) then
		native_raycasting.camera_delete(e.light_params.camera)
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
	e.position_z_center = 0.4
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
	e.visible = true
	e.physics_body = physics3d.create_rect(e.position.x, e.position.y, e.position_z_center, 0.5, 0.5, 0.8,
			false, physics3d.GROUPS.PLAYER, self.masks.PLAYER)
	e.physics_dynamic = true
	e.physics_obstacles_correction = vmath.vector3()
	e.camera_bob_info = {
		value = 0,
		height = 0.023,
		speed = 14,
		offset = 0,
		offset_weapon = 0,
	}
	e.hp = 100
	e.physics_body:set_user_data(e)
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
	e.visible = false

	if (e.wall_cell.native_cell:get_blocked()) then
		e.physics_body = physics3d.create_rect(e.position.x, e.position.y, e.position.z, 1, 1, 1, true, physics3d.GROUPS.OBSTACLE, self.masks.WALL)
		e.physics_static = true
		e.physics_body:set_user_data(e)
	end
	return e
end

---@param object LevelMapObject
function Entities:create_level_object(object)
	assert(object)
	---@type Entity
	local e = {}
	e.rotation_look_at_player = object.properties.rotation_look_at_player
	e.rotation_global = object.properties.rotation_global
	e.level_object = true
	e.map_object = object
	e.position = vmath.vector3(object.cell_xf, object.cell_yf, object.properties.position_z or 0)
	e.visible = false
	e.dynamic_color = true
	return e
end

---@param e Entity
---@param properties TileProperties
function Entities:add_base_properties(e, properties)
	if (properties.rotation_speed) then
		e.rotation_speed = properties.rotation_speed
	end
end

---@param properties TileProperties
function Entities:create_light_source(pos, properties)
	assert(pos)
	properties = properties or {}
	---@type Entity
	local e = {}
	e.position = vmath.vector3(pos.x, pos.y, pos.z)
	e.angle = vmath.vector3(properties.angle, 0, 0)
	e.light = true
	e.visible = false
	e.light_params = {
		light_power = properties.light_power or 1,
		start_light = vmath.vector3(properties.light_color.h, properties.light_color.s, properties.light_color.v),
		current_light = vmath.vector3(properties.light_color.h, properties.light_color.s, properties.light_color.v),
		camera = native_raycasting.camera_new()
	}
	e.light_params.camera:set_pos(pos.x, pos.y)
	e.light_params.camera:set_rays(properties.rays ~= -1 and properties.rays or 16)
	e.light_params.camera:set_fov(properties.fov ~= -1 and properties.fov or math.pi * 2)
	e.light_params.camera:set_max_dist(properties.light_distance or 1)
	self:add_base_properties(e,properties)
	return e
end

---@return Entity
function Entities:create_input(action_id, action)
	return { input_info = { action_id = action_id, action = action }, auto_destroy = true }
end

return Entities




