local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DrawDoorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("door")
System.name = "DrawDoorSystem"

---@param e Entity
function System:process(e)
	if e.visible and not e.door_object_go then
		e.door_object_go = FACTORIES.create_wall(vmath.vector3(e.position.x, e.position.z, -e.position.y), {transparent = false, base =  {tile_id = e.map_object.tile_id}})
		self.world:addEntity(e)
	elseif not e.visible and e.level_object_go then
		go.delete(e.door_object_go.root, true)
		e.door_object_go = nil
		self.world:addEntity(e)
	end
end


return System