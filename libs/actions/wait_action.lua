local COMMON = require "libs.common"
local BaseAction = require "libs.actions.action"

---@class WaitAction:Action
local Action = COMMON.class("WaitAction", BaseAction)

function Action:config_check(config)
	checks("?",{
		time = "number"
	})
end

function Action:act(dt)
	COMMON.coroutine_wait(self.config.time)
end
return Action