 local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")
---@class CameraSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player","position","angle")

---@param e Entity
function System:process(e, dt)
	native_raycasting.camera_update(e.position.x,e.position.y,-e.angle.x)
	native_raycasting.cells_update_visible(true)
	go.set_position(vmath.vector3(e.position.x,0.5+ (e.camera_bob_offset or 0),-e.position.y),CAMERA_URL)
	go.set_rotation(vmath.quat_rotation_y(e.angle.x), CAMERA_URL)
	--self:top_view(e)
end

function System:top_view(e)
	go.set_position(vmath.vector3(e.position.x,3,-e.position.y-2),CAMERA_URL)
	go.set_rotation(vmath.quat_rotation_x(180), CAMERA_URL)
end

return System