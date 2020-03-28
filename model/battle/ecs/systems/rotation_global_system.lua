local ECS = require 'libs.ecs'

---@class RotationGlobalSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("level_object_go","rotation_global")
System.name = "RotationGlobalSystem"

System.rotation_global = 0

---@param e Entity
function System:process(e, dt)
	local url = e.level_object_go.sprite or e.level_object_go.model
	go.set_rotation(self.quaternion,url)
end

---@param e Entity
function System:preProcess( dt)
	self.rotation_global = self.rotation_global + 2 * dt
	self.quaternion = vmath.quat_rotation_y(self.rotation_global)
end

return System