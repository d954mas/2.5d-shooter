local COMMON = require "libs.common"
local ENUMS = require "libs_project.enums"
local CONSTANTS = require "libs_project.constants"
local WeaponBase = require "model.battle.weapon.weapon_base"

---@class RifleWeapon:WeaponBase
local Weapon = COMMON.class("RifleWeapon", WeaponBase)

function Weapon:initialize()
	WeaponBase.initialize(self, CONSTANTS.GAME_CONFIG.WEAPONS[ENUMS.WEAPON.RIFLE])
end

return Weapon