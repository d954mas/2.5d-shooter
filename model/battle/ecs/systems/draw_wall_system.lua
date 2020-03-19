local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
local TILESET = require "model.battle.level.tileset"
--local CAMERA_URL = msg.url("game:/camera")
---@class DrawWallSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("wall")
System.name = "DrawWallSystem"

---@param e Entity
function System:preProcess()
	local need_load = native_raycasting.cells_get_need_load()
	for _, cell in ipairs(need_load) do
		local e = self.cells[cell:get_id()]
		if e then
			assert(not e.wall_go, "already loaded")
			e.wall_go = FACTORIES.create_wall(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.wall_cell)
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _, cell in ipairs(need_unload) do
		local e = self.cells[cell:get_id()]
		if e then
			go.delete(e.wall_go.root,true)
			e.wall_go = nil
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