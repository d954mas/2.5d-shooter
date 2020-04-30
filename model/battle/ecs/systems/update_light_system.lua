local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class UpdateLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light", "light_params")
System.name = "UpdateLightSystem"

local floor = math.floor
local vmath_length = vmath.length
local pow = math.pow

local tmpVec = vmath.vector3(0)
local time = 0
---@param e Entity
function System:process(e, dt)
	time = time + dt
	e.light_params.camera:set_angle(-e.angle.x)
	local neigbours = native_raycasting.camera_cast_rays(e.light_params.camera, true)
	local start_x = floor(e.position.x)
	local start_y = floor(e.position.y)
	for i = 1, #neigbours do
		local neigbour = neigbours[i]
		--for performance reason  update color only for visible cells
		if (neigbour:get_visibility()) then
			local light = self:get_light(neigbour:get_id())
			tmpVec.x = (start_x - neigbour:get_x())
			tmpVec.y = (start_y - neigbour:get_y())
			local dist = vmath_length(tmpVec)

			local v = e.light_params.light.v

			local h, s = e.light_params.light.h, e.light_params.light.s
			v = v * pow(e.light_params.light_power, dist)
			light[#light + 1] = native_raycasting.color_hsv_to_rgbi(h, s, v)
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
	local result = {}
	for id, values in pairs(self.lights) do
		local color_result = level.data.light_map[id]
		for _, color in ipairs(values) do
			color_result = native_raycasting.color_blend_additive(color_result, color)
		end
		result[id] = color_result
	end

	self.world.game.world.battle_model.light_map:set_colors(result)
end

return System