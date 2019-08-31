local ECS = require 'libs.ecs'
local FACTORY = require "scenes.game.factories"
local EMPTY_ROTATION = vmath.quat_rotation_z(0) -- without rotation object have strange rotation


--visual effects. When hit enemy add blood particles
--when hit wall add decales
--etc

---@class ObjectHitSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("hit_info")
---@param e Entity
function System:process(e, dt)
	local info = e.hit_info
	if info.target_e and not info.target_e.player then
		---@type Entity
		local blood_e = {}
		blood_e.position = vmath.vector3(info.target_e.position)
		local dpos = info.target_e.position-info.source_e.position
		dpos = vmath.normalize(dpos) * 0.1
		blood_e.position = blood_e.position - dpos
		blood_e.url_sprite = msg.url(factory.create(FACTORY.FACTORY.blood_particle,nil,EMPTY_ROTATION,nil,1/128*0.5))
		blood_e.url_go = msg.url(factory.create(FACTORY.FACTORY.empty,nil,EMPTY_ROTATION))
		go.set_position(vmath.vector3(0,0.4,0),blood_e.url_sprite)
		go.set_parent(blood_e.url_sprite,blood_e.url_go)
		go.set_position(vmath.vector3(blood_e.position.x,0, - blood_e.position.y),blood_e.url_go)
		blood_e.rotation_look_at_player = true
		blood_e.auto_destroy = false
		blood_e.auto_destroy_delay = 1

		self.world:addEntity(blood_e)
	end
	self.world:removeEntity(e)
end



return System