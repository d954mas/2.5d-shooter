local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawFloorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("floor")
System.name = "DrawFloorSystem"

---@param e Entity
function System:preProcess()
	local need_load = native_raycasting.cells_get_need_load()
	for _, cell in ipairs(need_load) do
		local e = self.cells[cell:get_id()]
		if e then
			assert(not e.floor_go, "already loaded")
			e.floor_go = FACTORIES.create_floor(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.floor_cell.tile_id)
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _, cell in ipairs(need_unload) do
		local e = self.cells[cell:get_id()]
		if e then
			assert(e.floor_go, "already loaded")
			go.delete(e.floor_go.root, true)
			e.floor_go = nil
		end
	end
end

function System:onModify()
	---@type Entity[]
	self.cells = {}
	for _, entity in ipairs(self.entities) do
		self.cells[entity.cell_id] = entity
	end
end

return System