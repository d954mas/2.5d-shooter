local COMMON = require "libs.common"
local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"
local WeaponBase = require "model.battle.weapon.weapon_base"

---@class ShotgunWeapon:WeaponBase
local Weapon = COMMON.class("ShotgunWeapon", WeaponBase)

function Weapon:initialize()
	WeaponBase.initialize(self, CONSTANTS.GAME_CONFIG.WEAPONS[ENUMS.WEAPON.SHOTGUN])
end

return Weapon