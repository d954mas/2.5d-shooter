 local ECS = require 'libs.ecs'
local HASH_OBJECT_POSITION = hash("object_position")
---@class UpdateObjectColorSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("render_dynamic_color","url_sprite")

---@param e Entity
function System:process(e, dt)
	sprite.set_constant(e.url_sprite,HASH_OBJECT_POSITION,vmath.vector4(e.pos.x,e.pos.y,e.pos.z,0))

end


return System