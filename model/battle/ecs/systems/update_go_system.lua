local ECS = require 'libs.ecs'
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_go")
System.name = "UpdateGoSystem"

---@param e Entity
function System:process(e, dt)
	--if e.position and not e.go_do_not_update_position then
		--local current_pos = vmath.vector3(e.position.x,e.position.z,-e.position.y)
--		go.set_position(current_pos,e.url_go)
	--end
	--if e.angle then
	--	go.set_rotation(vmath.quat_rotation_y(e.angle.x),e.url_go)
	--end
end


return System