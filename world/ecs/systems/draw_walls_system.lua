local ECS = require 'libs.ecs'
local DEBUG_INFO = require "debug.debug_info"
local WallRenderObject = require "scenes.game.view.render_objects.wall_render_object"
--Draw wall and floors

---@class DrawWallsSystem:ECSSystem
local System = ECS.system()

function System:initialize()
	---@type WallRenderObject[]
	self.wall_objects = {} --map key is cell_id value is url
end

System:initialize()

function System:update(dt)
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		local render_object = WallRenderObject({position = vmath.vector3(),cell_data = cell_data})
		render_object:create()
		render_object:show()
		self.wall_objects[cell_data.id] = render_object
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		local object = self.wall_objects[cell_data.id]
		if object then
			object:dispose()
			self.wall_objects[cell_data.id] = nil
		end
	end
	DEBUG_INFO.update_draw_walls_system(self)
end




return System