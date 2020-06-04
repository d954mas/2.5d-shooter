local COMMON = require "libs.common"
local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"
local SOUNDS = require "libs.sounds"
local WeaponBase = require "model.battle.weapon.player_weapon_base"

---@class ShotgunWeapon:PlayerWeaponBase
local Weapon = COMMON.class("ShotgunWeapon", WeaponBase)

function Weapon:initialize()
	WeaponBase.initialize(self, CONSTANTS.GAME_CONFIG.WEAPONS[ENUMS.WEAPON.SHOTGUN])
end

function Weapon:input_on_pressed()
	if(not self.shoot_co)then
		self.shoot_co = coroutine.create(function ()
			self:shoot_one()
		end)
	end
end

function Weapon:shoot_one()
	assert(self.shoot_co == coroutine.running())
	self:animation_set(self.config.animations.shoot)
	self.animation_current.playback = self.animation_current.PLAYBACK.FORWARD
	self.animation_current:restart(1)
	SOUNDS:play_sound({ name = self.config.sounds.shoot, url = self.config.sounds.shoot })
	while (not self.animation_current:is_finished()) do coroutine.yield() end

	self.animation_current.playback = self.animation_current.PLAYBACK.BACKWARD
	self.animation_current:restart(1)
	while (not self.animation_current:is_finished()) do
		coroutine.yield()
	end
	self:animation_set(self.config.animations.idle)
end

return Weapon