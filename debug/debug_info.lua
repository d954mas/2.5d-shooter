local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local M = {}

M.entities = 0
M.enemies = 0
M.walls = 0
M.walls_transparent = 0
M.walls_total = 0
M.draw_calls = 0
M.instances = 0

---@param game_controller GameController
function M.init(game_controller)
	M.GAME_CONTROLLER = game_controller
end

function M.update(dt)
	if M.GAME_CONTROLLER.level then
		M.entities = #M.GAME_CONTROLLER.level.ecs_world.ecs.entities
		M.enemies = COMMON.LUME.countp(ENTITIES.enemies)
	end
end


---@param system DrawWallsSystem
function M.update_draw_walls_system(system)
	M.walls = COMMON.LUME.countp(system.wall_objects)
	M.walls_transparent = COMMON.LUME.count(system.wall_objects,function(v) return v.transparent_object end)
	M.walls_total = M.walls + M.walls_transparent
end



return M