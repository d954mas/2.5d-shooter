local ENUMS = require "libs_project.enums"

local M = {}

M.GAME_SIZE = {
	width = 1920,
	height = 1080
}

M.DEBUG = {
	draw_light_map = false,
	draw_physics = false,
	draw_light_dynamic = false
}

M.GAME_CONFIG = {
	HP_1_HEAL = 15,
	WEAPONS = {
		[ENUMS.WEAPON.PISTOL] = { ammo = ENUMS.AMMO.PISTOL },
		[ENUMS.WEAPON.SHOTGUN] = { ammo = ENUMS.AMMO.SHOTGUN },
		[ENUMS.WEAPON.RIFLE] = { ammo = ENUMS.AMMO.RIFLE },
		[ENUMS.WEAPON.MINIGUN] = { ammo = ENUMS.AMMO.MINIGUN },
	},
	AMMO_START = {
		[ENUMS.AMMO.PISTOL] = 50,
		[ENUMS.AMMO.SHOTGUN] = 20,
		[ENUMS.AMMO.RIFLE] = 15,
		[ENUMS.AMMO.MINIGUN] = 400,
	}
}

return M
