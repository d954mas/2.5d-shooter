local COMMON = require "libs.common"
local RX = require "libs.rx"
local View = require "view.view_base"

--Incapsulate logic for view.

---@class Views
local Views = COMMON.class("Views")
local STATES = View.static.STATES

function Views:initialize()
	self.state = STATES.DISPOSED
	self.scheduler = RX.CooperativeScheduler.create()
end


function View:create(root_node_name)
	assert(not self.root, "view already created")
	assert(self.state == STATES.DISPOSED)
	self.root = root_node_name
	self.state = STATES.HIDE

end

function View:dispose()
	if self.state == STATES.SHOW then
		self:hide()
	end
	self.root = nil
	self.vh = nil
	self.state = STATES.DISPOSED
end

function View:show()
	assert(self.state == STATES.HIDE)
end
function View:hide()
	assert(self.state == STATES.SHOW)
end

function View:update(dt)
	self.scheduler:update(dt)
end

function View:on_input(action_id,action) end

function View:on_message( message_id, message, sender) end

return View