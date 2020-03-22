physics3d = {}

function physics3d.init() end
function physics3d.update() end
function physics3d.clear() end
function physics3d.create_rect(x, y, z, hw, hh, hl, static) end
function physics3d.destroy_rect(rect) end

---@class NativePhysicsRectBody
local NativePhysicsRectBody = {}
function NativePhysicsRectBody:is_static() end
function NativePhysicsRectBody:get_position() end
function NativePhysicsRectBody:get_size() end
function NativePhysicsRectBody:set_position(x,y,z) end