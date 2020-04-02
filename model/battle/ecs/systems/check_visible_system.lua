local ECS = require 'libs.ecs'

--local CAMERA_URL = msg.url("game:/camera")
---@class CheckVisibleSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("visible&(position|wall_cell)&!player")
System.name = "VisibleSystem"

--Some parts of object can be on next cell. So check all neighbours
local DX_DY = {
	{ -1, 0 },
	{ 0, 0 },
	{ 1, 0 },

	{ -1, 1 },
	{ 0, 1 },
	{ 1, 1 },

	{ -1, -1 },
	{ 0, -1 },
	{ 1, -1 },
}

---@param e Entity
function System:process(e, dt)
	if(e.wall_cell) then
		e.visible = e.player or e.wall_cell.native_cell:get_visibility()
	else
		local x, y = math.floor(e.position.x), math.floor(e.position.y)
		for  _, coords in ipairs (DX_DY) do
			local new_x, new_y = x + coords[1], y + coords[2]
			if(self.world.game.level:coords_valid(new_x,new_y)) then
				local visible = native_raycasting.cells_get_by_coords(new_x,new_y):get_visibility()
				if(visible) then
					e.visible = true
					return
				end
			end
		end
		e.visible = false
	end
end

return System