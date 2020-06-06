local ECS = require 'libs.ecs'

---@class RotationGlobalSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("rotation_global&(level_object_go|pickup_object_go|bullet_object_go)")
System.name = "RotationGlobalSystem"

System.rotation_global = 0

---@param e Entity
function System:process(e, dt)
	local go_object = e.level_object_go or e.pickup_object_go
	local url = go_object.sprite or go_object.model
	go.set_rotation(self.quaternion,url)
end

---@param e Entity
function System:preProcess( dt)
	self.rotation_global = self.rotation_global + 2 * dt
	self.quaternion = vmath.quat_rotation_y(self.rotation_global)
end

return System