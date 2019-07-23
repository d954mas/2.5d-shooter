local COMMON = require "libs.common"
local SOUNDS = require "libs.sounds"
local M = {}

M.ATTACK_TYPES = COMMON.read_only{
	RAYCASTING = "RAYCASTING",
	PROJECTILE = "PROJECTILE"
}

M.AMMO_TYPES = COMMON.read_only{
	PISTOL = "PISTOL",
	CHAINGUN = "CHAINGUN",
	MELEE = "MELEE" -- do not need ammo
}

M.INPUT_TYPE = COMMON.read_only{
	ON_PRESSED = "ON_PRESSED", --single shot for every click. Pistol
	WHILE_PRESSED = "WHILE_PRESSED", --shooting while pressed. Machine gun
	ON_RELEASED = "ON_RELEASED" --shooting when release. Some gun that charge it power.
}

M.TARGET = COMMON.read_only{
	ENEMIES = "ENEMIES",
	PLAYER = "PLAYER"
}

M.TARGET_HASHES = COMMON.read_only{
	ENEMIES = {COMMON.HASHES.MSG_PHYSICS_GROUP_ENEMY_DAMAGE,COMMON.HASHES.MSG_PHYSICS_GROUP_OBSTACLE},
	PLAYER = {COMMON.HASHES.MSG_PHYSICS_GROUP_PLAYER_DAMAGE,COMMON.HASHES.MSG_PHYSICS_GROUP_OBSTACLE},
}

---@class WeaponAnimation
---@field animation hash used only when player use that weapon
---@field duration number|nil

---@class WeaponAnimations
---@field idle WeaponAnimation
---@field shoot_prepare WeaponAnimation
---@field shoot WeaponAnimation
---@field shoot_after WeaponAnimation delay after raycast/projectile before next_shoot
---@field shoot_first_delay WeaponAnimation after user click before first raycast/projectile send
---@field shoot_empty WeaponAnimation after user click before first raycast/projectile send



---@class PlayerWeaponSounds
---@field idle table sound_obj
---@field empty table sound_obj

---@class WeaponPrototype
---@field tag string|nil used in logs
---@field attack_type string
---@field ammo_type string
---@field target string
---@field raycast_max_dist number
---@field reload_time number|nil
---@field clip number|nil
---@field input_type string
---@field player_weapon boolean|nil player_weapon should have icon, and animations for states.
---@field sounds PlayerWeaponSounds
---@field damage number
---@field animations WeaponAnimations

---@param prototype WeaponPrototype
function M.check_prototype(prototype)
	assert(prototype,"prototype can't be nil")
	assert(prototype.attack_type, "attack type can't be nil")
	if prototype.attack_type == M.ATTACK_TYPES.RAYCASTING then
		assert(type(prototype.raycast_max_dist)== "number","bad raycast_max_dist:" .. tostring(prototype.raycast_max_dist))
		assert(prototype.raycast_max_dist>0,"raycast_max_dist should be bigger 0")
	elseif prototype.attack_type== M.ATTACK_TYPES.PROJECTILE then
	else
		assert(nil,"unknown weapon attack_type:" .. prototype.attack_type)
	end
	assert(M.TARGET[prototype.target],"unknown target:" .. tostring(prototype.target))
	assert(M.AMMO_TYPES[prototype.ammo_type],"unknown ammo type:" .. tostring(prototype.ammo_type))
	assert(M.INPUT_TYPE[prototype.input_type],"unknown input type:" .. tostring(prototype.input_type))
	if prototype.clip then
		assert(prototype.reload_time,"need reload time,when have clip")
	end
	if prototype.player_weapon then
		assert(prototype.animations.idle,"should have idle animation")
	end
	assert(type(prototype.sounds)=="table")
	assert(prototype.damage)
	assert(prototype.animations)
	assert(prototype.animations.idle.duration)
	assert(prototype.animations.shoot_prepare.duration)
	assert(prototype.animations.shoot.duration)
	assert(prototype.animations.shoot_after.duration)
	assert(prototype.animations.shoot_first_delay.duration)

	return prototype
end

---@field idle WeaponAnimation
---@field shoot_prepare WeaponAnimation
---@field shoot WeaponAnimation
---@field shoot_after WeaponAnimation delay after raycast/projectile before next_shoot
---@field shoot_first_delay WeaponAnimation after user click before first raycast/projectile send
---@field shoot_empty WeaponAnimation

local function anim(duration,animation)
	assert(type(duration)=="number")
	return {duration =duration,  animation = animation and hash(animation)}
end

M.prototypes = COMMON.read_only_recursive{
	PISTOL = { attack_type = M.ATTACK_TYPES.RAYCASTING, ammo_type = M.AMMO_TYPES.PISTOL, target = M.TARGET.ENEMIES,
			   raycast_max_dist = 10, reload_time = 0, input_type = M.INPUT_TYPE.ON_PRESSED, player_weapon = true,
			   animations = { idle = anim(0, "pistol_1"), shoot_prepare = anim(0.1), shoot = anim(0.4,"pistol_shoot"),
							  shoot_after = anim(0), shoot_first_delay = anim(0),shoot_empty = anim(0.3) },
			   tag = "PISTOL",
			   sounds = { shoot = SOUNDS.sounds.game.weapon_pistol_shoot, empty = SOUNDS.sounds.game.weapon_pistol_empty },
			   damage = 25
	},
	CHAINGUN = { attack_type = M.ATTACK_TYPES.RAYCASTING, ammo_type = M.AMMO_TYPES.CHAINGUN, target = M.TARGET.ENEMIES,
			   raycast_max_dist = 10, reload_time = 0, input_type = M.INPUT_TYPE.WHILE_PRESSED, player_weapon = true,
			   animations = { idle = anim(0, "chaingun_1"), shoot_prepare = anim(0.1,"chaingun_prepare"), shoot = anim(0.2,"chaingun_shoot"),
							  shoot_after = anim(0), shoot_first_delay = anim(0),shoot_empty = anim(0.3) },
			   tag = "CHAINGUN",
			   sounds = { shoot = SOUNDS.sounds.game.weapon_pistol_shoot, empty = SOUNDS.sounds.game.weapon_pistol_empty },
			   damage = 5
	},
	ENEMY_MELEE = {attack_type = M.ATTACK_TYPES.RAYCASTING,ammo_type = M.AMMO_TYPES.MELEE,target = M.TARGET.PLAYER,
				   raycast_max_dist = 1, reload_time = 0, input_type = M.INPUT_TYPE.ON_PRESSED, player_weapon = false,
				   animations = { idle = anim(0), shoot_prepare = anim(0.1), shoot = anim(0.4),
								  shoot_after = anim(0), shoot_first_delay = anim(0),shoot_empty = anim(0) },
				   tag = "ENEMY MELEE",
				   sounds = {}, damage = 15
	}
}

return M