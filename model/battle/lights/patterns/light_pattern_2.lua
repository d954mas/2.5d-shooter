local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"
local Base = require "model.battle.lights.patterns.base_light_pattern"

---@class LightPattern2:LightPattern
local Pattern = COMMON.class("LightPattern2", Base)

function Pattern:initialize(...)
	Base.initialize(self, ...)
	self.animation_sequence = ACTIONS.Sequence()
	self.animation_sequence.drop_empty = false
	self:add_animation()
end

function Pattern:add_animation()
	local start_hsv = COMMON.LUME.clone_deep(self.start_light)
	start_hsv.v = 0
	local end_hsv = COMMON.LUME.clone_deep(start_hsv)
	end_hsv.h = end_hsv.h / 2
	end_hsv.s = end_hsv.s / 2
	end_hsv.v = 1
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = start_hsv, to = end_hsv, property = "light", time = 1 })
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = end_hsv, to = start_hsv, property = "light", time = 1 })
	self.animation_sequence:add_action(function() self:add_animation() end)
end

function Pattern:update(dt)
Base.update(self, dt)
self.animation_sequence:update(dt)
--pprint(self.e.light_params)
end

return Pattern