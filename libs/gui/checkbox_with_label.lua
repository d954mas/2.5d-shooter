local COMMON = require "libs.common"
local GOOEY = require "gooey.gooey"
local GOOEY_DIRTY_LARRY = require "gooey.themes.dirtylarry.dirtylarry"

local Btn = COMMON.class("ButtonScale")

function Btn:initialize(root_name, path)
	self.vh = {
		root = gui.get_node(root_name .. (path or "/root")),
	}
	self.root_name = root_name .. (path or "/root")
	self.gooey_listener = function(cb)
		self.checked = cb.checked
		if self.input_listener then self.input_listener() end
	end
	self.checked = false
end

function Btn:set_input_listener(listener)
	self.input_listener = listener
end

function Btn:set_checked(checked)
	self.checked = checked
	local cb = GOOEY_DIRTY_LARRY.checkbox(self.root_name)
	cb.set_checked(self.checked)
end

function Btn:on_input(action_id, action)
	if(not self.ignore_input)then
		local cb = GOOEY_DIRTY_LARRY.checkbox(self.root_name, action_id, action, self.gooey_listener)
		return cb.consumed
	end
end

function Btn:set_enabled(enable)
	gui.set_enabled(self.vh.root, enable)
end

function Btn:set_ignore_input(ignore)
	self.ignore_input = ignore
end

return Btn