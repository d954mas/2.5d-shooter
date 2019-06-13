 local ECS = require 'libs.ecs'
local CAMERA_URL = msg.url("game:/camera")
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("go_url")

---@param e Entity
function System:process(e, dt)
	if e.pos then
		local current_pos = vmath.vector3(e.pos.x,0.5,-e.pos.y)
		if e.tile and e.tile.origin then
			current_pos.y = current_pos.y + e.tile.origin.y
		end
		go.set_position(current_pos,e.go_url)
	end
	if e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x),e.go_url)
	end
end


return System