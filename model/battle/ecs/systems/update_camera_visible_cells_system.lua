local ECS = require 'libs.ecs'

---@class UpdateCameraVisibleCellsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player","position","angle")
System.name = "UpdateCameraVisibleCellsSystem"


---@param e Entity
function System:process(e, dt)
	native_raycasting.camera_update(e.position.x,e.position.y,-e.angle.x)
	native_raycasting.cells_update_visible(true)
end

return System