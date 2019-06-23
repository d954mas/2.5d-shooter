local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
---@class PhysicsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("physics","physics_message_id","physics_message","physics_source")
---@param e Entity
function System:process(e, dt)
	if e.physics_message_id == COMMON.HASHES.MSG_PHYSICS_CONTACT then
		self:handle_geometry(e,ENTITIES.get_entity_for_url(e.physics_source))
	end
	self.world:removeEntity(e)
end

 ---@param e Entity
 function System:handle_geometry(physics_e,e)
	 assert(physics_e)
	 assert(e)
	 local normal, distance = physics_e.physics_message.normal, physics_e.physics_message.distance
	 local correction = e.physics_obstacles_correction
	 if not correction then
		 --create correction vector
		 e.physics_obstacles_correction = vmath.vector3()
		 correction = e.physics_obstacles_correction
		self.world:addEntity(e)
	 end
	 if(vmath.length(normal * distance)<=0)then
		 return
	 end
	if distance > 0 then
		local proj = vmath.project(correction, normal * distance)
		if proj < 1 then
			local comp = (distance - distance * proj) * normal
			e.position.x = e.position.x + comp.x
			e.position.y = e.position.y - comp.z
			e.physics_obstacles_correction = correction + comp
		end
	end
 end


return System