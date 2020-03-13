local COMMON = require "libs.common"
local GOOEY = require "gooey.gooey"

local Btn = COMMON.class("ButtonIconText")

function Btn:initialize(root_name)
	self.vh = {
		root = gui.get_node(root_name .. "/root"),
		bg = gui.get_node(root_name .. "/bg"),
		icon = gui.get_node(root_name .. "/icon"),
		lbl = gui.get_node(root_name .. "/lbl"),
	}
	self.root_name = root_name .. "/root"
	self.scale_start = gui.get_scale(self.vh.root)
	self.gooey_listener = function()
		if self.input_listener then self.input_listener() end
	end
	self.btn_refresh_f = function(button)
		local scale = self.scale_start
		if button.pressed then
			gui.set_scale(button.node,self.scale_start * 0.9)
		else
			gui.set_scale(button.node,scale)
		end
	end
end

function Btn:set_input_listener(listener)
	self.input_listener = listener
end

function Btn:on_input(action_id,action)
	return GOOEY.button(self.root_name,action_id,action,self.gooey_listener,self.btn_refresh_f).consumed
end

return Btn