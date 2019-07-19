local ECS = require 'libs.ecs'

--visual effects. When hit enemy add blood particles
--when hit wall add decales
--etc

---@class ObjectHitSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("hit_info")
---@param e Entity
function System:process(e, dt)
	local info = e.hit_info
	self.world:removeEntity(e)
end



return System