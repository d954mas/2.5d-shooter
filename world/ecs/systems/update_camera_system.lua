local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")

---@class CameraSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player","pos","angle")

---@param e Entity
function System:process(e, dt)
	go.set_position(vmath.vector3(e.pos.x,0.5,-e.pos.y),CAMERA_URL)
	go.set_rotation(vmath.quat_rotation_y(e.angle.x), CAMERA_URL)
end


return System