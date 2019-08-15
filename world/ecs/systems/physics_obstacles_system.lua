local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local SOUNDS = require "libs.sounds"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
---@class PhysicsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("physics_info")
---@param e Entity
function System:process(e, dt)
	if e.physics_info.message_id == COMMON.HASHES.MSG_PHYSICS_CONTACT and e.physics_info.message.group == COMMON.HASHES.MSG_PHYSICS_GROUP_OBSTACLE then
		self:handle_geometry(e,ENTITIES.get_entity_for_url(e.physics_info.source))
	elseif e.physics_info.message_id == COMMON.HASHES.MSG_PHYSICS_COLLISION and  e.physics_info.message.group ==  COMMON.HASHES.MSG_PHYSICS_GROUP_PICKUP then
		self:handle_pickup(ENTITIES.get_entity_for_url(msg.url(e.physics_info.message.other_id)))
	end
end

---@param e Entity
function System:handle_pickup(e)
	if not e or  e.pickuped then return end
	local tile = e.tile
	local key = tile.properties.pickup_key
	local player = self.world.game_controller.level.player
	e.pickuped = true
	if key == "hp" and player.hp < 100 then
		player.hp = math.min(player.hp + 15,100)
		SOUNDS:play_sound(SOUNDS.sounds.game.object_health_pickup)
	elseif key == "ammo_pistol" then
		player.ammo[WEAPON_PROTOTYPES.AMMO_TYPES.PISTOL] = player.ammo[WEAPON_PROTOTYPES.AMMO_TYPES.PISTOL] + 10
		SOUNDS:play_sound(SOUNDS.sounds.game.object_ammo_pickup)
	end
	--disable because go will be deleted on next frame
	msg.post(e.url_go,COMMON.HASHES.MSG_DISABLE)
	self.world:removeEntity(e)
end

--https://www.defold.com/tutorials/runner/#_step_4_creating_a_hero_character
 ---@param e Entity
 function System:handle_geometry(physics_e,e)
	assert(physics_e)
	if not e then return end
	local normal, distance = physics_e.physics_info.message.normal, physics_e.physics_info.message.distance
	local correction = e.physics_obstacles_correction
	if not correction then
		--create correction vector
		e.physics_obstacles_correction = vmath.vector3()
		correction = e.physics_obstacles_correction
		self.world:addEntity(e)
	end
	if(vmath.length(normal * distance)<=0)then return end
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