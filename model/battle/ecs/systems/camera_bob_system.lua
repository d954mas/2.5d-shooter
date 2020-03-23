local ECS = require 'libs.ecs'

--local URL_WEAPON = msg.url("/weapon")
---@class CameraBobSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("camera_bob_info")
System.name = "CameraBobSystem"


---@param e Entity
function System:process(e, dt)
	e.camera_bob_info.value = e.camera_bob_info.value + dt * e.camera_bob_info.speed *
			math.min(vmath.length(e.movement.velocity),1);
	e.camera_bob_info.offset =  math.sin(e.camera_bob_info.value) * e.camera_bob_info.height;
	e.camera_bob_info.offset_weapon = math.sin(e.camera_bob_info.value*0.8+math.pi/2 ) * e.camera_bob_info.height * 4;
	self:weapon_set_bob_offset(e.camera_bob_info.offset_weapon)
end

function System:weapon_set_bob_offset(offset)
	--offset = offset * 150 - 15 -- -10 is dy to hide weapon bottom edge
	--local pos = vmath.vector3(960,offset,0)
--	go.set_position(pos,URL_WEAPON)
end

return System