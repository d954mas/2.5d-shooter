local COMMON = require "libs.common"

---@class HpBar
local Bar = COMMON.class("HpBar")

function Bar:initialize(root_name)
	checks("?", "string")
	self.progress = 0
	self.progress_max = 1
	self.root_name = assert(root_name)
	self:bind_vh()
	self.progress_config = {
		size_init = gui.get_size(self.vh.progress_fg)
	}
end

function Bar:bind_vh()
	self.vh = {
		root = gui.get_node(self.root_name .. "/root"),
		lbl_hp = gui.get_node(self.root_name .. "/lbl_hp"),
		progress_fg = gui.get_node(self.root_name .. "/progress_fg"),
	}
end

function Bar:set_progress_max(value)
	assert(value > 0)
	self.progress_max = value
	self:visual_update()
end
function Bar:set_progress(value)
	checks("?", "number")
	self.progress = COMMON.LUME.clamp(value, 0, self.progress_max)
	self:visual_update()
end

function Bar:visual_update()
	gui.set_text(self.vh.lbl_hp, math.floor(self.progress))
	local bar_size = self.progress_config.size_init
	gui.set_size(self.vh.progress_fg, vmath.vector3(self.progress / self.progress_max * bar_size.x,bar_size.y,bar_size.z))
end

function Bar:update(dt) end

return Bar