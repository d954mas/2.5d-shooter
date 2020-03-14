local COMMON = require "libs.common"
local TAG = "ENTITIES"

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
---@field door boolean
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


---@param url url key that used for mapping entity to url_go
local function url_to_key(url) return url.path end

---@class ENTITIES
local Entities = COMMON.class("Entities")

function Entities:initialize()

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

return Entities




