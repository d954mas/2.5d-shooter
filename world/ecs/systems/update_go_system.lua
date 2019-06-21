 local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_go")

---@param e Entity
function System:process(e, dt)
	if e.pos then
		local dy = e.pos_translate and e.pos_translate.y or 0.5
		local current_pos = vmath.vector3(e.pos.x,dy,-e.pos.y)
		go.set_position(current_pos,e.url_go)
	end
	if e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x),e.url_go)
	end
end


return System