local COMMON = require "libs.common"
local PERLIN = require "libs.perlin"

local Base = require "model.battle.lights.patterns.base_light_pattern"

---@class LightPattern3:LightPattern
local Pattern = COMMON.class("LightPattern3", Base)

function Pattern:initialize(...)
	Base.initialize(self, ...)
	self.seed = math.random()
	--self.config.speed = 3
	--self.config.power = 1.1
end

function Pattern:update(dt)
	Base.update(self, dt)
	local data = PERLIN.noise(self.time, 0, self.seed)

	self.e.light_params.light.v = COMMON.LUME.clamp(data + 1 / 2 * self.config.power, 0, 1)
end

return Pattern