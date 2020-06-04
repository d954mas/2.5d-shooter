local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
local CONSTANTS = require "libs_project.constants"

---@class DrawDebugLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light")
System.name = "DrawDebugLight"

System.added_lights = {}

---@param e Entity
function System:process(e, dt)
	local id = native_raycasting.cells_get_by_coords(e.position.x, e.position.y):get_id()
	if ((not e.visible or not CONSTANTS.DEBUG.draw_light_debug_object) and e.debug_light_go) then
		go.delete(e.debug_light_go.root, true)
		e.debug_light_go = nil
		self.added_lights[id] = nil
		self.world:addEntity(e)
	elseif ((e.visible and CONSTANTS.DEBUG.draw_light_debug_object) and not e.debug_light_go) then
		e.debug_light_go = FACTORIES.create_debug_light(e)
		self.added_lights[id] = self.added_lights[id] or {}
		table.insert(self.added_lights[id],e)
		e.position.z = 0.20+0.17*#self.added_lights[id]
		self.world:addEntity(e)
	end

	if (e.debug_light_go) then
		local r, g, b = native_raycasting.color_hsv_to_rgb(e.light_params.light.h, e.light_params.light.s, e.light_params.light.v)
		local color = vmath.vector4(r / 255, g / 255, b / 255, 1)
		sprite.set_constant(e.debug_light_go.north, "tint", color)
		sprite.set_constant(e.debug_light_go.south, "tint", color)
		sprite.set_constant(e.debug_light_go.east, "tint", color)
		sprite.set_constant(e.debug_light_go.west, "tint", color)
		sprite.set_constant(e.debug_light_go.top, "tint", color)
		sprite.set_constant(e.debug_light_go.bottom, "tint", color)
	end
end

return System