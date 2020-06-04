local ECS = require 'libs.ecs'
local COMMON = require "libs.common"

---@class WeaponPlayerTintSystem:ECSSystem
local System = ECS.system()
System.name = "WeaponPlayerTintSystem"

local WEAPON_URL = msg.url("game_scene:/weapon/origin#sprite")

local count = function(power, v)
	return power + v / 255 * (1 - power)
end

function System:update(dt)
	if (not self.camera) then
		self.camera = native_raycasting.camera_new()
		self.camera:set_rays(16)
		self.camera:set_fov(math.pi * 2)
		self.camera:set_max_dist(1)
	end
	--use 9 near cells to count weapon color
	--if use only current, weapon blink when change cell
	self.camera:set_pos(self.world.game.player.position.x, self.world.game.player.position.y)
	local neigbours = native_raycasting.camera_cast_rays(self.camera, true)
	local colors = {}
	local total_weight = 0
	for _, neigbour in ipairs(neigbours) do
		if (not neigbour:get_blocked()) then
			local r, g, b = native_raycasting.color_rgbi_to_rgb(neigbour:get_color())
			local dist = vmath.length(vmath.vector3(neigbour:get_x() + 0.5, neigbour:get_y() + 0.5, 0) - vmath.vector3(self.world.game.player.position.x, self.world.game.player.position.y, 0))
			local weight = 1 / dist
			total_weight = total_weight + weight
			table.insert(colors, { r = r, g = g, b = b, weight = weight })
		end
	end
	local r, g, b = 0, 0, 0
	for _, color in ipairs(colors) do
		local mul = color.weight / total_weight
		if(color.weight == math.huge) then mul = 1 end
		r = r + color.r * mul
		g = g + color.g * mul
		b = b + color.b * mul
	end
	local color = vmath.vector4(count(0.4, r), count(0.4, g), count(0.4, b), 1)
	sprite.set_constant(WEAPON_URL, "tint", color)
end

return System