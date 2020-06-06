local ECS = require 'libs.ecs'
---@class UpdateGoSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("level_object_go|debug_light_go|door_object_go|bullet_object_go")
System.name = "UpdateGoSystem"

---@param e Entity
function System:process(e, dt)
	local go_object = e.level_object_go or e.debug_light_go or e.door_object_go or e.bullet_object_go
	local url_go = assert(go_object.root)

	if (not url_go) then return end
	if e.position then
		local current_pos = vmath.vector3(e.position.x, e.position.z, -e.position.y)
		go.set_position(current_pos,url_go)
	end

	if e.rotation_look_at_player_quaternion then
		go.set_rotation(e.rotation_look_at_player_quaternion, url_go)
	elseif e.angle then
		go.set_rotation(vmath.quat_rotation_y(e.angle.x), url_go)
	end

end

return System