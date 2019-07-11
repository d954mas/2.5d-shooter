 local ECS = require 'libs.ecs'
local HASH_OBJECT_POSITION = hash("object_position")
---@class UpdateObjectColorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("dynamic_color","url_sprite")


--it break batching.Maybe store center position in coordinates.Storing in coordinates break physics.
--set color only for visible.Invisible use same cell.Reduces draw calls
--change sprite constant only on changes.Reduces messages
--
---@param e Entity
function System:process(e, dt)
	local cell_x,cell_y = math.ceil(e.position.x), math.ceil(e.position.y)
	local visible = native_raycasting.cells_get_by_coords(cell_x,cell_y):get_visibility()
	local color_cell =  visible and vmath.vector4(cell_x-0.5,cell_y-0.5,0,0) or vmath.vector4(0,0,0,0)
	if e.dynamic_color_cell ~= color_cell then
		e.dynamic_color_cell = color_cell
		sprite.set_constant(e.url_sprite,HASH_OBJECT_POSITION,e.dynamic_color_cell)
	end
end


return System