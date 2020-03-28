local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawLevelObjectSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("level_object")
System.name = "DrawLevelObjectSystem"

---@param e Entity
function System:process(e)
	if e.visible and not e.level_object_go then
		e.level_object_go = FACTORIES.create_level_object(vmath.vector3(e.position.x, e.position.z, -e.position.y), e.map_object)
		self.world:addEntity(e)
	elseif not e.visible and e.level_object_go then
		go.delete(e.level_object_go.root, true)
		e.level_object_go = nil
		self.world:addEntity(e)
	end
end

return System