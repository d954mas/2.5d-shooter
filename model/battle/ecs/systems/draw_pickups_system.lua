local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawPickupsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("pickup_object")
System.name = "DrawPickupsSystem"

---@param e Entity
function System:process(e)
	if e.visible and not e.pickup_object_go then
		e.pickup_object_go = FACTORIES.create_pickup(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.map_object)
		self.world:addEntity(e)
	elseif not e.visible and e.pickup_object_go then
		go.delete(assert(e.pickup_object_go.root), true)
		e.pickup_object_go = nil
		self.world:addEntity(e)
	end
end

return System