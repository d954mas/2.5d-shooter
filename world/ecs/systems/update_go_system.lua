 local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("go_url")

---@param e Entity
function System:process(e, dt)
	if e.pos then
		go.set_position(vmath.vector3(e.pos.x,0.5,-e.pos.y),e.go_url)
	end
	if e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x),e.go_url)
	end
end


return System