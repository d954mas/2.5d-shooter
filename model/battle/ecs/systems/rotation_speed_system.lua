local ECS = require 'libs.ecs'

---@class RotationSpeedSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("angle&&rotation_speed")
System.name = "RotationSpeedSystem"


---@param e Entity
function System:process(e, dt)
	e.angle.x = e.angle.x + e.rotation_speed*dt
end



return System