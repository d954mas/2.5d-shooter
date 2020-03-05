local COMMON = require "libs.common"
local TweenAction = require "libs.actions.tween_action"

---@class TweenActionGUI:Action
local Action = COMMON.class("TweenActionGUI", TweenAction)

function Action:config_get_from()
	local f = self.config_get_from_f
	if not f then
		local name = "get_" .. self.config.property
		f = gui[name]
		assert(f, "no property in gui:" .. name)
		self.config_get_from_f = f
	end

	return self:config_value_to_table(f(self.config.object))
end

--region set_value
function Action:set_property()
	local f = self.set_property_f
	if not f then
		local name = "set_" .. self.config.property
		f = gui[name]
		assert(f, "can't set property in gui:" .. name)
	end
	return f(self.config.object, self:config_table_to_value(self.tween_value))
end

return Action