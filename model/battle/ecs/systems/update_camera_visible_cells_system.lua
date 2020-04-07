local ECS = require 'libs.ecs'

---@class UpdateCameraVisibleCellsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player","position","angle")
System.name = "UpdateCameraVisibleCellsSystem"


---@param e Entity
function System:process(e, dt)
	self.world.game.world.battle_model.native_camera.camera:set_pos(e.position.x, e.position.y)
	self.world.game.world.battle_model.native_camera.camera:set_angle(-e.angle.x)
	native_raycasting.camera_set_main(self.world.game.world.battle_model.native_camera.camera)
	native_raycasting.cells_update_visible(true)
end

return System