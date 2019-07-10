local COMMON = require "libs.common"
local StatesBase = require "world.states_base"
---@class AIStates
local AT_STATES = {
	CREATED = "CREATED",
	SPAWN = "SPAWN",
	IDLE = "IDLE"
}
---@class AI
local AI = COMMON.class("AIBase",StatesBase)

---@param e Entity
---@param game_controller GameController
function AI:initialize(e,game_controller)
	StatesBase.initialize(self,AT_STATES,e,game_controller)
	self:change_state(self.states.CREATED)
end


return AI