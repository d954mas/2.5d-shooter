local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawDebugLightSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("light")
System.name = "DrawDebugLight"

---@param e Entity
function System:process(e, dt)
	if (not e.visible and e.debug_physics_body_go) then
		go.delete(e.debug_light_go.root, true)
		e.debug_light_go = nil
		self.world:addEntity(e)
	elseif(e.visible and not e.debug_light_go) then
		e.debug_light_go = FACTORIES.create_debug_light(e)
		self.world:addEntity(e)
	end
end

return System