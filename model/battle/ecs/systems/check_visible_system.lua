local ECS = require 'libs.ecs'
local LOG = require "libs.log"
--local CAMERA_URL = msg.url("game:/camera")
---@class CheckVisibleSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("visible&(position|wall_cell)")
System.name = "VisibleSystem"

---@param e Entity
function System:process(e, dt)
	local cell = e.wall_cell and e.wall_cell.native_cell
	if not cell then
		local x, y = math.ceil(e.position.x), math.ceil(e.position.y)
		cell = native_raycasting.cells_get_by_coords(x, y)
	end
	if not cell then LOG.w("no cell for entity", System.name) return end
	e.visible = e.player or cell:get_visibility()
end

return System