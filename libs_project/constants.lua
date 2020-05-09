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
		[ENUMS.WEAPON.PISTOL] = {
			key = ENUMS.WEAPON.PISTOL,
			ammo = ENUMS.AMMO.PISTOL,
								  animations = {
									  origin = vmath.vector3(0,84/2,0),
									  idle = { hash("pistol") }
								  } },
		[ENUMS.WEAPON.SHOTGUN] = {
			key = ENUMS.WEAPON.SHOTGUN,
			ammo = ENUMS.AMMO.SHOTGUN,
								   animations = {
									   origin = vmath.vector3(0,99/2,0),
									   idle = { hash("shotgun") }
								   } },
		[ENUMS.WEAPON.RIFLE] = {
			key = ENUMS.WEAPON.RIFLE,
			ammo = ENUMS.AMMO.RIFLE,
								 animations = {
									 origin = vmath.vector3(0,105/2,0),
									 idle = { hash("rifle") }
								 } },
		[ENUMS.WEAPON.MINIGUN] = {
			key = ENUMS.WEAPON.MINIGUN,
			ammo = ENUMS.AMMO.MINIGUN,
								   animations = {
									   origin = vmath.vector3(0,86/2,0),
									   idle = { hash("minigun") }
								   } },
	},
	AMMO_START = {
		[ENUMS.AMMO.PISTOL] = 50,
		[ENUMS.AMMO.SHOTGUN] = 20,
		[ENUMS.AMMO.RIFLE] = 15,
		[ENUMS.AMMO.MINIGUN] = 400,
	}
}

return M
