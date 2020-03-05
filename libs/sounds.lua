local COMMON = require "libs.common"

local TAG = "Sound"
local Sounds = COMMON.class("Sounds")

--gate https://www.defold.com/manuals/sound/
function Sounds:initialize()
	self.gate_time = 0.1
	self.gate_sounds = {}
	self.sounds = {

	}
end

function Sounds:update(dt)
	for k, v in pairs(self.gate_sounds) do
		self.gate_sounds[k] = v - dt
		if self.gate_sounds[k] < 0 then
			self.gate_sounds[k] = nil
		end
	end
end

function Sounds:play_sound(sound_obj)
	assert(sound_obj)
	assert(type(sound_obj) == "table")
	assert(sound_obj.url)
	if not self.gate_sounds[sound_obj] then
		self.gate_sounds[sound_obj] = self.gate_time
		sound.play(sound_obj.url)
		COMMON.i("play sound:" .. sound_obj.name, TAG)
	else
		COMMON.i("gated sound:" .. sound_obj.name .. "time:" .. self.gate_sounds[sound_obj], TAG)
	end
end

return Sounds()