local COMMON = require "libs.common"

---@class LightPattern
local Pattern = COMMON.class("LightPattern")

---@param e Entity
function Pattern:initialize(e)
	self.e = assert(e)
	self.config = self.e.light_pattern_config
	self.config .speed = self.config.speed or 1
	self.time = 0
	---@type ColorHSV
	self.start_light = COMMON.LUME.clone_deep(self.e.light_params.light)
end

function Pattern:update(dt)
	self.dt = dt * self.config.speed
	self.time = self.time + self.dt
end

return Pattern