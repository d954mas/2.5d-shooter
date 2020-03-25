local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game_scene:/camera")
---@class UpdateCameraSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player","position","angle")
System.name = "UpdateCameraPositionSystem"

--update camera position.It will show position of prev frame.
--show prev because new sprites will be rendered at next frame
---@param e Entity
function System:process(e, dt)
	go.set_position(vmath.vector3(e.position.x,0.5+ (e.camera_bob_info and e.camera_bob_info.offset or 0),-e.position.y),CAMERA_URL)
	go.set_rotation(vmath.quat_rotation_y(e.angle.x), CAMERA_URL)
	--self:top_view(e)
end

--debug top down view
function System:top_view(e)
--	go.set_position(vmath.vector3(e.position.x,3,-e.position.y-2),CAMERA_URL)
--	go.set_rotation(vmath.quat_rotation_x(180), CAMERA_URL)
end

return System