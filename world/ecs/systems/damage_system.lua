local ECS = require 'libs.ecs'
local SOUNDS = require "libs.sounds"
local SM = require("libs.sm.sm")
local CURSOR_HELPER = require "libs.cursor_helper"
local ENTITIES = require "world.ecs.entities.entities"
---@class DamageSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("damage_info")
---@param e Entity
function System:process(e, dt)
	local info = e.damage_info
	if info.target_e.hp and info.target_e.hp > 0 and not info.target_e.ignore_damage then
		info.target_e.hp = math.max(0,info.target_e.hp - info.weapon_prototype.damage)
		if not info.target_e.player then
			ENTITIES.create_flash_info(0.3,info.target_e)
		end
		if info.target_e.hp == 0 and not info.target_e.player then
			--TMP remove unit.Move to ai
			SOUNDS:play_sound(SOUNDS.sounds.game.monster_blob_die)
			info.target_e.ai = nil
			info.target_e.movement_velocity = nil
			self.world:addEntity(info.target_e)
			timer.delay(0.3,false,function ()
				self.world:removeEntity(info.target_e)
			end)
		end
		if info.target_e.player then
			info.target_e.ignore_damage = true
			timer.delay(2,false,function() info.target_e.ignore_damage  = false end)
			SOUNDS:play_sound_player_hurt()
			if info.target_e.hp == 0 then
				CURSOR_HELPER.unlock_cursor()
				SM:show("GameOverModal")
			else
				self.world.game_controller:player_receive_damage()
			end
		end
	end
	self.world:removeEntity(e)
end



return System