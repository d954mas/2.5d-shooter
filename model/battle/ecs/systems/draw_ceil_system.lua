local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
---@class DrawCeilSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("ceil")
System.name = "DrawCeilSystem"

---@param e Entity
function System:preProcess()
	local need_load = native_raycasting.cells_get_need_load()
	for _, cell in ipairs(need_load) do
		local e = self.cells[cell:get_id()]
		assert(not e.ceil_go, "already loaded")
		assert(e.visible, "not visible")
		e.ceil_go = FACTORIES.create_ceil(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.ceil_cell.tile_id)
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _, cell in ipairs(need_unload) do
		local e = self.cells[cell:get_id()]
		assert(e.ceil_go, "already loaded")
		assert(not e.visible, "visible")
		go.delete(e.ceil_go.root)
		e.ceil_go = nil
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