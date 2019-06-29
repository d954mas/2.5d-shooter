local ECS = require 'libs.ecs'
---@class CameraBobSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("camera_bob")

---@param e Entity
function System:process(e, dt)
	e.camera_bob = e.camera_bob + dt * e.camera_bob_speed * math.min(math.abs(e.velocity.x) + math.abs(e.velocity.y),1) * e.speed;
	e.camera_bob_offset =  math.sin(e.camera_bob) * e.camera_bob_height;
	e.weapon_bob_offset = math.sin(e.camera_bob+math.pi/2) * e.camera_bob_height * 4;
	self.world.world:weapon_set_bob_offset(e.weapon_bob_offset)
end


return System