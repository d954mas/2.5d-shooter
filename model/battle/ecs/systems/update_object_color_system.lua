local ECS = require 'libs.ecs'
local HASH_OBJECT_POSITION = hash("object_position")
---@class UpdateObjectColorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("dynamic_color&(level_object_go|pickup_object_go)")
System.name = "UpdateObjectColorSystem"

--it break batching.Maybe store center position in coordinates.Storing in coordinates break physics.
--set color only for visible.Invisible use same cell.Reduces draw calls
--change sprite constant only on changes.Reduces messages


---@param e Entity
function System:process(e, dt)
	local cell_x, cell_y = math.ceil(e.position.x), math.ceil(e.position.y)
	local object = e.level_object_go or e.pickup_object_go
	local url_sprite = object.sprite
	if url_sprite then
		sprite.set_constant(url_sprite, HASH_OBJECT_POSITION, vmath.vector4(cell_x + 0.5, cell_y + 0.5, 0, 0))
	end
end

return System