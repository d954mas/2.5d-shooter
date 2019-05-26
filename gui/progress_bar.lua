local COMMON = require "libs.common"
local LUME = require "libs.lume"

---@class ProgressBar
local Bar = COMMON.class("GuiBar")


function Bar:initialize(nodes)
	assert(nodes, "model can't be nil")
	self.root = assert(nodes.root, "need root node")
	self.background = assert(nodes.background, "need background node")
	self.show_text = false
	if nodes.label then
		self.label = nodes.label
		self.show_text = true
	end
	self.max_value = 1
	self.background_size = gui.get_size(self.background)
	self.background_max_width =self.background_size.x
end

function Bar:set_show_text(v)
	assert(not(v and self.label), "can't show text when label not set")
	self.show_text = v
end

function Bar:set_max_value(value)
	assert(value)
	self.max_value = value
end

function Bar:set_progress(progress)
	local percents = LUME.clamp(progress/self.max_value,0,1)
	self.background_size.x = self.background_max_width * percents
	gui.set_size(self.background, self.background_size)
	if self.show_text then
	--	gui.set_text(self.label, progress .. "/" .. self.max_value)
	end
end


return Bar
