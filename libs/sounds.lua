local COMMON = require "libs.common"

local TAG = "Sound"
local Sounds = COMMON.class("Sounds")

--gate https://www.defold.com/manuals/sound/
function Sounds:initialize()
	self.gate_time = 0.1
	self.gate_sounds = {}
	self.sounds = {
		game = {
			object_health_pickup = {url = msg.url("game:/sounds#object_health_pickup"),name = "object_health_pickup"},
			object_ammo_pickup = {url = msg.url("game:/sounds#object_ammo_pickup"),name = "object_ammo_pickup"},
			player_hurt_1 = {url = msg.url("game:/sounds#player_hurt_1"),name ="player_hurt_1"},
			player_hurt_2 = {url = msg.url("game:/sounds#player_hurt_2"),name ="player_hurt_2"},
			player_hurt_3 = {url = msg.url("game:/sounds#player_hurt_3"),name ="player_hurt_3"},
			weapon_pistol_shoot = {url = msg.url("game:/sounds#weapon_pistol_shoot"),name ="weapon_pistol_shoot"},
			weapon_pistol_empty = {url = msg.url("game:/sounds#weapon_pistol_empty"),name ="weapon_pistol_empty"},
			monster_blob_die = {url = msg.url("game:/sounds#monster_blob_die"),name ="monster_blob_die"},
		}
	}
end

function Sounds:update(dt)
	for k,v in pairs(self.gate_sounds) do
		self.gate_sounds[k] = v - dt
		if self.gate_sounds[k] < 0 then
			self.gate_sounds[k] = nil
		end
	end
end

function Sounds:play_sound_player_hurt()
	local sound = self.sounds.game["player_hurt_" .. math.random(3)]
	self:play_sound(sound)
end

function Sounds:play_sound(sound_obj)
	assert(sound_obj)
	assert(type(sound_obj)=="table")
	assert(sound_obj.url)
	if not self.gate_sounds[sound_obj] then
		self.gate_sounds[sound_obj] = self.gate_time
		sound.play(sound_obj.url)
		COMMON.i("play sound:" .. sound_obj.name,TAG)
	else
		COMMON.i("gated sound:" .. sound_obj.name  .. "time:" .. self.gate_sounds[sound_obj],TAG)
	end
end

return Sounds()