local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
local TILESET = require "model.battle.level.tileset"
--local CAMERA_URL = msg.url("game:/camera")
---@class DrawDebugPhysicsBodiesSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("physics_body")
System.name = "DrawDebugPhysicsBodies"

---@param e Entity
function System:process(e, dt)
	if (not e.visible and e.debug_physics_body_go) then
		go.delete(e.debug_physics_body_go.root, true)
		e.debug_physics_body_go = nil
	elseif(e.visible and not e.debug_physics_body_go) then
		e.debug_physics_body_go = FACTORIES.create_debug_physics_body(e.physics_body)
	elseif(e.debug_physics_body_go and e.physics_dynamic)then
		--update position
		local x, y, z = e.physics_body:get_position()
		go.set_position(vmath.vector3(x, z, -y),e.debug_physics_body_go.root)
	end
end

return System