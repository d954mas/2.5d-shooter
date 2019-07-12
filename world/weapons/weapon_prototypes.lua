local COMMON = require "libs.common"
local SOUNDS = require "libs.sounds"
local M = {}

M.ATTACK_TYPES = COMMON.read_only{
	RAYCASTING = "RAYCASTING",
	PROJECTILE = "PROJECTILE"
}

M.AMMO_TYPES = COMMON.read_only{
	PISTOL = "PISTOL",
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
	ENEMIES = {hash("enemy")},
	PLAYER = {hash("player")}
}

---@class PlayerWeaponSounds
---@field idle table sound_obj
---@field empty table sound_obj

---@class PlayerWeaponAnimations
---@field idle string

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
---@field animations PlayerWeaponAnimations
---@field sounds PlayerWeaponSounds
---@field first_shot_delay number after user click before first raycast/projectile send
---@field shoot_time_delay number delay after raycast/projectile before next_shoot
---@field damage number

---@param ptototype WeaponPrototype
function M.check_prototype(ptototype)
	assert(ptototype,"prototype can't be nil")
	assert(ptototype.attack_type, "attack type can't be nil")
	if ptototype.attack_type == M.ATTACK_TYPES.RAYCASTING then
		assert(type(ptototype.raycast_max_dist)== "number","bad raycast_max_dist:" .. tostring(ptototype.raycast_max_dist))
		assert(ptototype.raycast_max_dist>0,"raycast_max_dist should be bigger 0")
	elseif ptototype.attack_type== M.ATTACK_TYPES.PROJECTILE then

	else
		assert(nil,"unknown weapon attack_type:" .. ptototype.attack_type)
	end
	assert(M.TARGET[ptototype.target],"unknown target:" .. tostring(ptototype.target))
	assert(M.AMMO_TYPES[ptototype.ammo_type],"unknown ammo type:" .. tostring(ptototype.ammo_type))
	assert(M.INPUT_TYPE[ptototype.input_type],"unknown input type:" .. tostring(ptototype.input_type))
	if ptototype.clip then
		assert(ptototype.reload_time,"need reload time,when have clip")
	end
	if ptototype.player_weapon then
		assert(ptototype.animations.idle,"should have idle animation")
	end
	assert(type(ptototype.sounds)=="table")
	assert(ptototype.shoot_time_delay)
	assert(ptototype.first_shot_delay)
	assert(ptototype.damage)
	return ptototype
end

M.prototypes = COMMON.read_only_recursive{
	PISTOL = {attack_type = M.ATTACK_TYPES.RAYCASTING,ammo_type = M.AMMO_TYPES.PISTOL,target = M.TARGET.ENEMIES,
			  raycast_max_dist = 10, reload_time = 0, input_type = M.INPUT_TYPE.ON_PRESSED, player_weapon = true,
			  animations = {idle = hash("pistol_1")}, tag = "PISTOL",
			  sounds = { shoot = SOUNDS.sounds.game.weapon_pistol_shoot, empty = SOUNDS.sounds.game.weapon_pistol_empty },
			  first_shot_delay = 0.1,shoot_time_delay = 0.4, damage = 25
	},
	ENEMY_MELEE = {attack_type = M.ATTACK_TYPES.RAYCASTING,ammo_type = M.AMMO_TYPES.MELEE,target = M.TARGET.PLAYER,
				   raycast_max_dist = 1, reload_time = 0, input_type = M.INPUT_TYPE.ON_PRESSED, player_weapon = false,
				   tag = "ENEMY MELEE",sounds = {}, first_shot_delay = 0.1,shoot_time_delay = 0.4, damage = 15
	}
}

return M