local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"
local COMMON = require "libs.common"

---@class DrawBulletSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("bullet")
System.name = "DrawBulletSystem"

---@param e Entity
function System:process(e)
	if e.visible and not e.bullet_object_go then
		e.bullet_object_go = FACTORIES.create_draw_object_with_sprite(FACTORIES.URLS.factory.effect_sprite ,vmath.vector3(e.position.x, e.position.z, -e.position.y),
				COMMON.HASHES.hash("bullet_weapon_pistol"),0.001)
		self.world:addEntity(e)
	elseif not e.visible and e.bullet_object_go then
		go.delete(e.bullet_object_go.root, true)
		e.bullet_object_go = nil
		self.world:addEntity(e)
	end
end

return System