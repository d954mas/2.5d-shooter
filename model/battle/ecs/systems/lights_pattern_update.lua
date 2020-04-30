local ECS = require 'libs.ecs'

---@class LightPatternUpdateSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light_pattern")
System.name = "LightPatternUpdateSystem"

---@param e Entity
function System:process(e, dt)
	e.light_pattern:update(dt)
end

return System