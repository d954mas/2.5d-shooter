local COMMON = require "libs.common"
local SOUNDS = require "libs.sounds"

local TAG = "WEAPON"

---@class PlayerWeaponConfigSounds
---@field shoot userdata

---@class PlayerWeaponConfigAnimations
---@field idle Animation
---@field shoot Animation
---@field origin vector3

---@class PlayerWeaponConfig
---@field key string
---@field ammo string
---@field animations PlayerWeaponConfigAnimations
---@field sounds PlayerWeaponConfigSounds

---@class PlayerWeaponBase
local Weapon = COMMON.class("WeaponBase")

local PLAYER_WEAPON_URLS = {
	root = msg.url("game_scene:/weapon"),
	scale = msg.url("game_scene:/weapon/scale"),
	origin = msg.url("game_scene:/weapon/origin"),
	sprite = msg.url("game_scene:/weapon/origin#sprite"),
}

---@param config PlayerWeaponConfig
function Weapon:initialize(config)
	checks("?", {
		key = "string",
		ammo = "string",
		animations = {
			origin = "userdata",
			idle = "Animation",
			shoot = "Animation"
		},
		sounds = {
			shoot = "userdata"
		}
	})
	self.animation_current = config.animations.idle
	self.sprite_image = nil
	self.state_active = false
	self.config = config
	self.shoot_co = nil --shoot coroutine
end

function Weapon:state_active_set(state)
	self.state_active = state
	if (self.state_active) then
		go.set_position(self.config.animations.origin, PLAYER_WEAPON_URLS.origin)
		self:animation_set(self.config.animations.idle)
	else
		self:animation_set(self.config.animations.idle)
		self.pressed = false
		self.shoot_co = nil
		self.sprite_image = nil
	end
end

function Weapon:sprite_set_image(image)
	assert(image)
	if (self.sprite_image ~= image) then
		self.sprite_image = image
		sprite.play_flipbook(PLAYER_WEAPON_URLS.sprite, self.sprite_image)
	end
end

function Weapon:update(dt)
	self:update_all(dt)
	if (self.state_active) then
		self:update_active(dt)
	end
end

function Weapon:update_all(dt)
end

function Weapon:update_active(dt)
	if (self.shoot_co) then
		self.shoot_co = COMMON.COROUTINES.coroutine_resume(self.shoot_co)
	end
	self.animation_current:update(dt)
	self:sprite_set_image(self.animation_current:get_frame())
end

function Weapon:state_is_active()
	return self.state_active
end

function Weapon:animation_set(animation)
	self.animation_current = animation
	self.animation_current:restart()
end

function Weapon:input_on_pressed()

end

function Weapon:input_on_released()

end

function Weapon:input_pressed()
	COMMON.LOG.i(self.config.key .. " pressed", TAG)
	self.pressed = true
	self:input_on_pressed()
end

function Weapon:input_released()
	COMMON.LOG.i(self.config.key .. " released", TAG)
	self.pressed = false
	self:input_on_released()
end

--animate to shoot state
--then animate back
--make only one shoot
function Weapon:shoot_one()
	assert(self.shoot_co == coroutine.running())
	self:animation_set(self.config.animations.shoot)
	self.animation_current.playback = self.animation_current.PLAYBACK.FORWARD
	self.animation_current:restart(1)
	while (not self.animation_current:is_finished()) do coroutine.yield() end
	SOUNDS:play_sound({ name = self.config.sounds.shoot, url = self.config.sounds.shoot })
	self.animation_current.playback = self.animation_current.PLAYBACK.BACKWARD
	self.animation_current:restart(1)
	while (not self.animation_current:is_finished()) do
		coroutine.yield()
	end
	self:animation_set(self.config.animations.idle)
end

return Weapon