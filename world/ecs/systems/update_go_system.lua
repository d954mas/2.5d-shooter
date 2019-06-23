 local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_go")

---@param e Entity
function System:process(e, dt)
	if e.pos then
		local current_pos = vmath.vector3(e.pos.x,0,-e.pos.y)
		go.set_position(current_pos,e.url_go)
	end
	if e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x),e.url_go)
	end
end


return System