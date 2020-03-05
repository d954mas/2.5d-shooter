local COMMON = require "libs.common"
local TweenAction = require "libs.actions.tween_action"

---@class TweenActionTable:Action
local Action = COMMON.class("TweenAction", TweenAction)

--region set_value
function Action:set_property()
	self.config.object[self.config.property] = self:config_table_to_value(self.tween_value)
end

function Action:config_get_from()
	local data = assert(self.config.object[self.config.property], "no property in table:" .. self.config.property)
	return self:config_value_to_table(data)
end

return Action