local ECS = require 'libs.ecs'
---@class UpdateAISystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("ai")
System.name = "UpdateAISystem"

---@param e Entity
function System:process(e, dt)
	e.ai:update(dt)
end


return System