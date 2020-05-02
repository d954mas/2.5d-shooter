physics3d = {}

physics3d.GROUPS = {
	OBSTACLE = 1,
	PICKUPS = 2,
	PLAYER = 4,
	ENEMY = 8,
}

function physics3d.init() end
function physics3d.update() end
function physics3d.clear() end
function physics3d.create_rect(x, y, z, hw, hh, hl, static, group, mask) end
function physics3d.destroy_rect(rect) end
function physics3d.raycast(x, y, z, x2, y2, z2, mask) end

---@return NativePhysicsCollisionInfo[]
function physics3d.get_collision_info() end

---@class NativePhysicsCollisionManifoldPointInfo
---@field point1 vector3
---@field point2 vector3
---@field normal vector3
---@field depth number

---@class NativePhysicsCollisionManifoldInfo
---@class points NativePhysicsCollisionManifoldPointInfo[]

---@class NativePhysicsCollisionInfo
---@field body1 NativePhysicsRectBody
---@field body2 NativePhysicsRectBody
---@field manifolds NativePhysicsCollisionManifoldInfo[]

---@class NativePhysicsRectBody
local NativePhysicsRectBody = {}
function NativePhysicsRectBody:is_static() end
function NativePhysicsRectBody:get_position() end
function NativePhysicsRectBody:get_size() end
function NativePhysicsRectBody:set_position(x, y, z) end
function NativePhysicsRectBody:set_user_data(data) end
---@return Entity|nil
function NativePhysicsRectBody:get_user_data() end