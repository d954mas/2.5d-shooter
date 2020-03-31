local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class UpdateLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light")
System.name = "UpdateLightSystem"

---@param e Entity
function System:process(e, dt)
	local id = self.world.game.level:coords_to_id(e.position.x, e.position.y)+1
	local light = self:get_light(id)
	table.insert(light, 0xffffffff)
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
	local base_colors = COMMON.LUME.clone_deep(level.data.light_map)
	for id, values in pairs(self.lights) do
		for _, color in ipairs(values) do
			base_colors[id] = bit.bor(bit.tobit(base_colors[id]), bit.tobit(color))
		end
	end

	self.world.game.world.battle_model.light_map:set_colors(base_colors, level.data.size.x, level.data.size.y)
end

return System