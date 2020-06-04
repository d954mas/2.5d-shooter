local ECS = require 'libs.ecs'
local COMMON = require "libs.common"

---@class WeaponPlayerUpdateSystem:ECSSystem
local System = ECS.system()
System.name = "WeaponPlayerUpdateSystem"

function System:update(dt)
	local weapons = self.world.game.player.weapons
	for k, weapon in pairs(weapons) do
		weapon:update(dt)
	end
end

return System