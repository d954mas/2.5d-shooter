local ECS = require 'libs.ecs'
--local CAMERA_URL = msg.url("game:/camera")
---@class DrawCeilSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("floor")
System.name = "DrawCeilSystem"

---@param e Entity
function System:process(e, dt)

	--self:top_view(e)
end

return System