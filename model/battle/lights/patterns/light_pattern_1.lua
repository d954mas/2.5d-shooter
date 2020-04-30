local COMMON = require "libs.common"
local Base = require "model.battle.lights.patterns.base_light_pattern"

---@class LightPattern1:LightPattern
local Pattern = COMMON.class("LightPattern1", Base)

function Pattern:update(dt)
	Base.update(self, dt)
	self.e.light_params.current_light.z = (math.sin(self.time)+1)/2
end

return Pattern