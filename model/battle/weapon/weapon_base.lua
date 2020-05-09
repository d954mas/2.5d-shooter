local COMMON = require "libs.common"

---@class WeaponBase
local Weapon = COMMON.class("WeaponBase")

Weapon.STATES = {
	HIDE = "hide",
	SHOWING = "showing",
	HIDING = "hiding",
	ACTIVE = "active"
}

local PLAYER_WEAPON_URLS = {
	root = msg.url("game_scene:/weapon"),
	scale = msg.url("game_scene:/weapon/scale"),
	origin = msg.url("game_scene:/weapon/origin"),
	sprite = msg.url("game_scene:/weapon/origin#sprite"),
}

function Weapon:initialize(config)
	checks("?", {
		key = "string",
		ammo = "string",
		animations = {
			origin = "userdata",
			idle = "table"
		}
	})
	self.config = config
	self:state_set(Weapon.STATES.HIDE)
end

function Weapon:state_set(state)
	self.state = assert(state)
	if (self.state == Weapon.STATES.ACTIVE) then
		self:animation_idle()
	end
end

function Weapon:state_is_active()
	return self.state == Weapon.STATES.ACTIVE
end

function Weapon:animation_idle()
	go.set_position(self.config.animations.origin, PLAYER_WEAPON_URLS.origin)
	sprite.play_flipbook(PLAYER_WEAPON_URLS.sprite, self.config.animations.idle[1])
end

return Weapon