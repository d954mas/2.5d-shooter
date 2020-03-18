local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
---@class DrawCeilSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("ceil")
System.name = "DrawCeilSystem"

---@param e Entity
function System:process(e, dt)
	if (e.visible and not e.ceil_go) then
		e.ceil_go = FACTORIES.create_ceil(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.floor_cell.tile_id)
	elseif (not e.visible and e.ceil_go) then
		go.delete(e.ceil_go.root)
		e.ceil_go = nil
	end
end

return System