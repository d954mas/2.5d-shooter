local ECS = require 'libs.ecs'
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_go")
System.name = "UpdateGoSystem"

---@param e Entity
function System:process(e, dt)
	if (not e.url_go) then return end
	if e.position then
		local current_pos = vmath.vector3(e.position.x, e.position.z, -e.position.y)
		go.set_position(current_pos, e.url_go)
	end

	if e.rotation_look_at_player_quaternion then
		go.set_rotation(e.rotation_look_at_player_quaternion, e.url_go)
	elseif e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x), e.url_go)
	end

end

return System