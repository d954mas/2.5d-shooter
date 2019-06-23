local COMMON = require "libs.common"

--Incapsulate logic for view.

---@class View
local View = COMMON.class("ViewBase")

local STATES = {SHOW = "SHOW", HIDE = "HIDE", DISPOSED = "DISPOSED"}

View.static.STATES = STATES

function View:initialize()
	self.states = STATES
	self.state = STATES.DISPOSED
	self.views = {}
end

---@param view View
function View:add_view(view,root_node_name)
	table.insert(self.views,{view = assert(view,"no view"), root_node_name = assert(root_node_name,"no root name")})
end

function View:create()
	assert(self.state == STATES.DISPOSED)
	for _,v in ipairs(self.views) do v.view:create(v.root_node_name) end
	self.state = STATES.HIDE
end

function View:dispose()
	if self.state == STATES.SHOW then self:hide() end
	for _,v in ipairs(self.views) do v.view:dispose() end
	self.state = STATES.DISPOSED
end

function View:show()
	assert(self.state == STATES.HIDE)
	for _,v in ipairs(self.views) do v.view:show() end
end
function View:hide()
	assert(self.state == STATES.SHOW)
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