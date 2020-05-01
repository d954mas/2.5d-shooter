local Animation = require "libs.animation"

local M = {}

M.wall26 = { frames = { hash("wall26")--, hash("wall26_2"), hash("wall26_3")
}, fps = 5, playback = Animation.PLAYBACK.FORWARD, loops = -1 }

function M.get_animation(key)
	assert(key)
	return assert(M[key], "no animation:" .. key)
end

return M