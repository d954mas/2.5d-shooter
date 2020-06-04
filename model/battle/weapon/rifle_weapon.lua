local COMMON = require "libs.common"
local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"
local WeaponBase = require "model.battle.weapon.player_weapon_base"

---@class RifleWeapon:PlayerWeaponBase
local Weapon = COMMON.class("RifleWeapon", WeaponBase)

function Weapon:initialize()
	WeaponBase.initialize(self, CONSTANTS.GAME_CONFIG.WEAPONS[ENUMS.WEAPON.RIFLE])
end

function Weapon:input_on_pressed()
	if(not self.shoot_co)then
		self.shoot_co = coroutine.create(function ()
			self:shoot_one()
		end)
	end
end

return Weapon