local COMMON = require "libs.common"
local GOOEY = require "gooey.gooey"

local Btn = COMMON.class("ButtonScale")

function Btn:initialize(root_name, path)
	self.vh = {
		root = gui.get_node(root_name .. (path or "/root")),
	}
	self.scale = 0.9
	self.root_name = root_name .. (path or "/root")
	self.scale_start = gui.get_scale(self.vh.root)
	self.gooey_listener = function()
		if self.input_listener then self.input_listener() end
	end
	self.btn_refresh_f = function(button)
		local scale = self.scale_start
		if button.pressed then
			gui.set_scale(button.node, self.scale_start * self.scale)
		else
			gui.set_scale(button.node, scale)
		end
	end
end

function Btn:set_input_listener(listener)
	self.input_listener = listener
end

function Btn:on_input(action_id, action)
	return not self.ignore_input and GOOEY.button(self.root_name, action_id, action, self.gooey_listener, self.btn_refresh_f).consumed
end

function Btn:set_enabled(enable)
	gui.set_enabled(self.vh.root, enable)
end

function Btn:set_ignore_input(ignore)
	self.ignore_input = ignore
end

return Btn