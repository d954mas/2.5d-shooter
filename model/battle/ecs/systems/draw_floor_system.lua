local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
local TILESET = require "model.battle.level.tileset"
--local CAMERA_URL = msg.url("game:/camera")
---@class DrawFloorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("floor")
System.name = "DrawFloorSystem"

---@param e Entity
function System:process(e, dt)
	if (e.visible and not e.floor_go) then
		e.floor_go = FACTORIES.create_floor(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.floor_cell.tile_id)
	elseif (not e.visible and e.floor_go) then
		go.delete(e.floor_go.root)
		e.floor_go = nil
	end
end

return System