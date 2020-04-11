local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class UpdateLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light", "light_params")
System.name = "UpdateLightSystem"

local tmpVec = vmath.vector3(0)
local time = 0
---@param e Entity
function System:process(e, dt)
	time = time + dt
	e.light_params.camera:set_angle(-e.angle.x)
	local neigbours = native_raycasting.camera_cast_rays(e.light_params.camera, true)
	local start_x = math.floor(e.position.x)
	local start_y = math.floor(e.position.y)
	for i = 1, #neigbours do
		local neigbour = neigbours[i]
		--for performance reason  update color only for visible cells
		--if(neigbour:get_visibility())then
		local light = self:get_light(neigbour:get_id())
		tmpVec.x = (start_x - neigbour:get_x())
		tmpVec.y = (start_y - neigbour:get_y())
		local dist = vmath.length(tmpVec)

		e.light_params.current_light.x = e.light_params.start_light.x
		e.light_params.current_light.y = e.light_params.start_light.y
		e.light_params.current_light.z = e.light_params.start_light.z

		local v = e.light_params.current_light.z
		--debug tested light pulse
		--if(v>0.3)then
		--	v = COMMON.LUME.clamp(v + math.sin(time/60)*v*0.8,0,1)
		--end
		local h, s = e.light_params.current_light.x, e.light_params.current_light.y
		v = v * math.pow(e.light_params.light_power, dist)
		table.insert(light, native_raycasting.color_hsv_to_rgbi(h,s,v))
		--end

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
		result[id] = level.data.light_map[id]
		for _, color in ipairs(values) do
			result[id] = native_raycasting.color_blend_additive(result[id], color)
		end
	end

	self.world.game.world.battle_model.light_map:set_colors(result, self.world.game.level.data.light_map)
end

return System