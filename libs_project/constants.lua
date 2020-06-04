local ENUMS = require "libs_project.enums"
local Animation = require "libs.animation"

local M = {}

M.GAME_SIZE = {
	width = 1920,
	height = 1080
}

M.DEBUG = {
	draw_light_map = false,
	draw_physics = false,
	draw_light_debug_object = false,
	draw_light_dynamic = false
}

M.GAME_CONFIG = {
	HP_1_HEAL = 15,
	WEAPONS = {
		[ENUMS.WEAPON.PISTOL] = {
			key = ENUMS.WEAPON.PISTOL,
			ammo = ENUMS.AMMO.PISTOL,
			animations = {
				origin = vmath.vector3(0, 84 / 2, 0),
				idle = Animation { frames = { hash("pistol")}, fps = 30, loops = -1, playback = Animation.PLAYBACK.PING_PONG },
				shoot = Animation { frames = { hash("pistol"),hash("pistol_2")}, fps = 10, loops = 1, playback = Animation.PLAYBACK.FORWARD },
			},
			sounds = {
				shoot = msg.url("game_scene:/sounds#weapon_pistol_shoot")
			}
		},
		[ENUMS.WEAPON.SHOTGUN] = {
			key = ENUMS.WEAPON.SHOTGUN,
			ammo = ENUMS.AMMO.SHOTGUN,
			animations = {
				origin = vmath.vector3(0, 99 / 2, 0),
				idle = Animation { frames = { hash("shotgun")}, fps = 30, loops = -1, playback = Animation.PLAYBACK.PING_PONG  },
				shoot = Animation { frames = { hash("shotgun"),hash("shotgun_2")}, fps = 10, loops = 1, playback = Animation.PLAYBACK.FORWARD },
			},
			sounds = {
				shoot = msg.url("game_scene:/sounds#weapon_shootgun_shoot")
			}

		},
		[ENUMS.WEAPON.RIFLE] = {
			key = ENUMS.WEAPON.RIFLE,
			ammo = ENUMS.AMMO.RIFLE,
			animations = {
				origin = vmath.vector3(0, 105 / 2, 0),
				idle = Animation { frames = { hash("rifle")}, fps = 30, loops = -1, playback = Animation.PLAYBACK.PING_PONG  },
				shoot = Animation { frames = { hash("rifle"),hash("rifle_2")}, fps = 10, loops = 1, playback = Animation.PLAYBACK.FORWARD },
			},
			sounds = {
				shoot = msg.url("game_scene:/sounds#weapon_rifle_shoot")
			}

		},
		[ENUMS.WEAPON.MINIGUN] = {
			key = ENUMS.WEAPON.MINIGUN,
			ammo = ENUMS.AMMO.MINIGUN,
			animations = {
				origin = vmath.vector3(0, 86 / 2, 0),
				idle = Animation { frames = { hash("minigun")}, fps = 30, loops = -1, playback = Animation.PLAYBACK.PING_PONG },
				shoot = Animation { frames = { hash("minigun"),hash("minigun_2")}, fps = 10, loops = 1, playback = Animation.PLAYBACK.FORWARD },
			},
			sounds = {
				shoot = msg.url("game_scene:/sounds#weapon_minigun_shoot")
			}

		}
	},
	AMMO_START = {
		[ENUMS.AMMO.PISTOL] = 50,
		[ENUMS.AMMO.SHOTGUN] = 20,
		[ENUMS.AMMO.RIFLE] = 15,
		[ENUMS.AMMO.MINIGUN] = 400,
	}
}

return M
