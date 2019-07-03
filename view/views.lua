local COMMON = require "libs.common"
local ViewBase = require "view.view_base"
--TODO FIX WHEN START USE

---@class View
local View = COMMON.class("Views",ViewBase)

function View:initialize()
	ViewBase.initialize(self)
	self.views = {}
end

---@param view View
function View:add_view(view,root_node_name)
	table.insert(self.views,{view = assert(view,"no view"), root_node_name = assert(root_node_name,"no root name")})
end

function View:create()
	assert(self.state == self.STATES.DISPOSED)
	for _,v in ipairs(self.views) do v.view:create(v.root_node_name) end
	self.state = self.STATES.HIDE
end

function View:dispose()
	if self.state == self.STATES.SHOW then self:hide() end
	for _,v in ipairs(self.views) do v.view:dispose() end
	self.state = self.STATES.DISPOSED
end

function View:show()
	assert(self.state == self.STATES.HIDE)
	for _,v in ipairs(self.views) do v.view:show() end
end
function View:hide()
	assert(self.state == self.STATES.SHOW)
	for _,v in ipairs(self.views) do v.view:hide() end
end

function View:update(dt)
	for _,v in ipairs(self.views) do v.view:update(dt) end
end

function View:on_input(action_id,action)
	for _,v in ipairs(self.views) do v.view:on_input(action_id,action) end
end

function View:on_message( message_id, message, sender)
	for _,v in ipairs(self.views) do v.view:on_message( message_id, message, sender) end
end

return View