local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local SOUNDS = require "libs.sounds"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
---@class DamageSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("damage_info")
---@param e Entity
function System:process(e, dt)
	local info = e.damage_info
	if info.target_e.hp and info.target_e.hp > 0 then
		info.target_e.hp = math.max(0,info.target_e.hp - info.weapon_prototype.damage)
		if info.target_e.hp == 0 then
			SOUNDS:play_sound(SOUNDS.sounds.game.monster_blob_die)
			self.world:removeEntity(info.target_e)
		end
	end
	self.world:removeEntity(e)
end



return System