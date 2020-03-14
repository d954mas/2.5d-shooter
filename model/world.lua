local COMMON = require "libs.common"
local BattleModel = require "model.battle.battle_model"

---@class World
---@field battle_model BattleModel|nil
local World = COMMON.class("World")

function World:initialize()

end

function World:update(dt)
	if self.battle_model then self.battle_model:update(dt) end
end

function World:final()
	self:battle_model_final()
end

---@param level Level
function World:battle_set_level(level)
	checks("?", "Level")
	assert(not self.battle_model, "battle model already created")
	self.battle_model = BattleModel(self,level)
end



function World:battle_model_final()
	if self.battle_model then
		self.battle_model:final()
		self.battle_model = nil
	end
end

return World()

