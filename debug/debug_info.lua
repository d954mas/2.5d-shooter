local WORLD = require "model.world"

--UPDATE SOME INFO.
--THAT INFO USED BY DEBUG GUI
local M = {}

M.entities = 0

function M.init()
end
---@return number walls draw
---@return number floors draw
---@return number ceils draw

---@param ecs GameEcsWorld
local function count_walls(ecs)
	local walls, floors, ceils = 0, 0, 0

	local entities = ecs.ecs.entities
	for i=1, #ecs.ecs.entities do
		local entity = entities[i]
		if (entity.floor_go) then floors = floors + 1 end
		if (entity.ceil_go) then ceils = ceils + 1 end
		if (entity.wall_go) then walls = walls + 1 end
	end
	return walls, floors, ceils
end

function M.update(dt)
	local have_ecs = WORLD.battle_model and WORLD.battle_model.ecs and WORLD.battle_model.ecs
	M.entities = have_ecs and #have_ecs.ecs.entities or 0
	M.walls, M.floors, M.ceils = 0, 0, 0
	if (have_ecs) then M.walls, M.floors, M.ceils = count_walls(have_ecs) end

end

return M