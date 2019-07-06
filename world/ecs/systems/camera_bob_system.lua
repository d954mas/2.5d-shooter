local ECS = require 'libs.ecs'

local URL_WEAPON = msg.url("/weapon")
---@class CameraBobSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("camera_bob")


---@param e Entity
function System:process(e, dt)
	e.camera_bob = e.camera_bob + dt * e.camera_bob_speed * math.min(math.abs(e.velocity.x) + math.abs(e.velocity.y),1) * e.speed;
	e.camera_bob_offset =  math.sin(e.camera_bob) * e.camera_bob_height;
	e.weapon_bob_offset = math.sin(e.camera_bob+math.pi/2) * e.camera_bob_height * 4;
	self:weapon_set_bob_offset(e.weapon_bob_offset)
end

function System:weapon_set_bob_offset(offset)
	offset = offset * 200 - 10 -- -10 is dy to hide weapon bottom edge
	local pos = vmath.vector3(960,offset,0)
	go.set_position(pos,URL_WEAPON)
end

return System