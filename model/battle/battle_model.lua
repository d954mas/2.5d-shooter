local COMMON = require "libs.common"

---@class BattleModel
local Model = COMMON.class("BattleModel")

---@param level Level
function Model:initialize(level)
	self.level = assert(level)
end

function Model:update(dt) end

function Model:on_input(action, action_id) end

function Model:final()
	self.level = nil
end

return Model