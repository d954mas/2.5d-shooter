local COMMON = require "libs.common"
local TEXT_SETTING = require "libs_project.text_settings"
local RICHTEXT = require "richtext.richtext"

local Lbl = COMMON.CLASS("RichtextLbl")

function Lbl:initialize()
	self.nodes = nil
	self.text_metrics = nil
	self.text = nil
	self.root_node = gui.new_box_node(vmath.vector3(0), vmath.vector3(1))
	self:set_text_setting(TEXT_SETTING.BASE_CENTER)
	self:set_font("Base")
end

function Lbl:set_parent(parent)
	gui.set_parent(self.root_node,assert(parent))
end

function Lbl:set_font(font)
	checks("?", "string")
	self.font = font
end

function Lbl:set_text_setting(config)
	checks("?", "table")
	self.text_setting = TEXT_SETTING.make_copy(config, { parent = self.root_node })
end

function Lbl:set_text(text)
	checks("?", "string")
	if(self.text == text) then
		return
	end
	self.text = text
	if (self.nodes) then
		for _, node in ipairs(self.nodes) do
			gui.delete_node(node.node)
		end
	end
	self.nodes, self.text_metrics = RICHTEXT.create(self.text, self.font, self.text_setting)
end

return Lbl