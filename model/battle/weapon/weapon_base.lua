local COMMON = require "libs.common"

local Weapon = COMMON.class("WeaponBase")

function Weapon:initialize(config)
	checks("?",{
		ammo = "number"
	})
	self.config = config
end

return Weapon