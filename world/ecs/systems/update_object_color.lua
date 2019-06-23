 local ECS = require 'libs.ecs'
local HASH_OBJECT_POSITION = hash("object_position")
---@class UpdateObjectColorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("dynamic_color","url_sprite")

---@param e Entity
function System:process(e, dt)
	sprite.set_constant(e.url_sprite,HASH_OBJECT_POSITION,vmath.vector4(e.position.x,e.position.y,e.position.z,0))

end


return System