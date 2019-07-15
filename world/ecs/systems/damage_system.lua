local ECS = require 'libs.ecs'
local SOUNDS = require "libs.sounds"
---@class DamageSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("damage_info")
---@param e Entity
function System:process(e, dt)
	local info = e.damage_info
	if info.target_e.hp and info.target_e.hp > 0 then
		info.target_e.hp = math.max(0,info.target_e.hp - info.weapon_prototype.damage)
		if info.target_e.hp == 0 and not info.target_e.player then
			SOUNDS:play_sound(SOUNDS.sounds.game.monster_blob_die)
			self.world:removeEntity(info.target_e)
		end
		if info.target_e.player then
			info.target_e.ignore_damage = true
			timer.delay(2,false,function() info.target_e.ignore_damage  = false end)
			SOUNDS:play_sound_player_hurt()
			if info.target_e.hp == 0 then
				require("libs.cursor_helper").unlock_cursor()
				require("libs.sm.sm"):show("GameOverModal")
			end
		end
	end
	self.world:removeEntity(e)
end



return System