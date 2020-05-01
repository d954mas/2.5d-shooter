local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"
local TWEEN = require "libs.tween"
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
	local start_hsv = COMMON.LUME.clone_deep(self.start_light);
	start_hsv.v = 0.7
	local color_2 = COMMON.LUME.clone_deep(start_hsv);
	color_2.v = 0.4
	local color_3 = COMMON.LUME.clone_deep(start_hsv);
	color_3.v = 0.6
	local color_4 = COMMON.LUME.clone_deep(start_hsv);
	color_4.v = 0.75
	local color_5 = COMMON.LUME.clone_deep(start_hsv);
	color_5.v = 0.5
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = start_hsv, to = color_2,
															property = "light", time = 0.3, easing = TWEEN.easing.outQuad })
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = color_2, to = color_3,
															property = "light", time = 0.15, easing = TWEEN.easing.inQuad })
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = color_3, to = color_4,
															property = "light", time = 0.35, easing = TWEEN.easing.linear })
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = color_4, to = color_5,
															property = "light", time = 0.15, easing = TWEEN.easing.linear })
	self.animation_sequence:add_action(ACTIONS.TweenTable { object = self.e.light_params, from = color_5, to = start_hsv,
															property = "light", time = 0.2, easing = TWEEN.easing.inQuad })
	self.animation_sequence:add_action(function() self:add_animation() end)
end

function Pattern:update(dt)
	Base.update(self, dt)
	self.animation_sequence:update(dt)
end

return Pattern