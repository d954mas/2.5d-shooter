local ECS = require 'libs.ecs'

---@class WeaponTintSystem:ECSSystem
local System = ECS.system()
System.name = "WeaponTintSystem"

local WEAPON_URL = msg.url("game_scene:/weapon/origin#sprite")

local count = function(power,v)
	return power + v/255*(1-power)
end

function System:update(dt)
	local cell = self.world.game.level:map_get_wall_by_coords(self.world.game.player.position.x,self.world.game.player.position.y)
	local color = cell.native_cell:get_color()
	local r,g,b = native_raycasting.color_rgbi_to_rgb(color)
	color = vmath.vector4(count(0.4,r),count(0.4,g),count(0.4,b),1)
	sprite.set_constant(WEAPON_URL,"tint",color)
end

return System