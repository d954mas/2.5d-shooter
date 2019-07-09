 local ECS = require 'libs.ecs'
local HASH_OBJECT_POSITION = hash("object_position")
---@class UpdateObjectColorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("dynamic_color","url_sprite")


--it break batching.Maybe store center position in coordinates.Storing in coordinates break physics.
---@param e Entity
function System:process(e, dt)
	sprite.set_constant(e.url_sprite,HASH_OBJECT_POSITION,vmath.vector4(math.ceil(e.position.x)-0.5,math.ceil(e.position.y)-0.5,math.ceil(e.position.z),0))
end


return System