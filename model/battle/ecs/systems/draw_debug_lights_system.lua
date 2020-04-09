local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawDebugLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light")
System.name = "DrawDebugLight"

---@param e Entity
function System:process(e, dt)
	if (not e.visible and e.debug_light_go) then
		go.delete(e.debug_light_go.root, true)
		e.debug_light_go = nil
		self.world:addEntity(e)
	elseif(e.visible and not e.debug_light_go) then
		e.debug_light_go = FACTORIES.create_debug_light(e)
		self.world:addEntity(e)
	end


	if(e.debug_light_go) then
		local r,g,b = native_raycasting.color_hsv_to_rgb(e.light_params.current_light.x,e.light_params.current_light.y,e.light_params.current_light.z)
		local color = vmath.vector4(r/255,g/255,b/255,1)
		sprite.set_constant(e.debug_light_go.north,"tint",color)
		sprite.set_constant(e.debug_light_go.south,"tint",color)
		sprite.set_constant(e.debug_light_go.east,"tint",color)
		sprite.set_constant(e.debug_light_go.west,"tint",color)
		sprite.set_constant(e.debug_light_go.top,"tint",color)
		sprite.set_constant(e.debug_light_go.bottom,"tint",color)
	end
end

return System