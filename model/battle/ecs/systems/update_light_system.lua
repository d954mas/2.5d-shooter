local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class UpdateLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light")
System.name = "UpdateLightSystem"

---@param e Entity
function System:process(e, dt)
	local id = self.world.game.level:coords_to_id(e.position.x, e.position.y)
	local neigbours = self.world.game.level:map_get_neighbours(id,1)
	for i=0,#neigbours do
		local neigbour = neigbours[i]
		--for performance reason  update color only for visible cells
		if(neigbour:get_visibility())then
			local light = self:get_light(neigbour:get_id())
			table.insert(light, 0x333333)
		end

	end

end

function System:get_light(id)
	local light = self.lights[id]
	if (light == nil) then
		light = {}
		self.lights[id] = light
	end
	return light
end

function System:preProcess()
	self.lights = {}
end


function System:postProcess()
	local level = self.world.game.level
	local base_colors = COMMON.LUME.clone_deep(level.data.light_map)--base colors ids start from 1. But other id start from 0
	for id, values in pairs(self.lights) do
		local cell = native_raycasting.cells_get_by_id(id)
		--for performance reason  update color only for visible cells
		if(cell:get_visibility()) then
			for _, color in ipairs(values) do
				base_colors[id+1] = native_raycasting.color_blend_additive(base_colors[id+1] ,color)
			end
		end

	end

	self.world.game.world.battle_model.light_map:set_colors(base_colors, level.data.size.x, level.data.size.y)
end

return System