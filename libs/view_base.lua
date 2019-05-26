local COMMON = require "libs.common"
local RX = require "libs.rx"

---@class View
local View = COMMON.class("ViewBase")

local STATES = {SHOW = "SHOW", HIDE = "HIDE", DISPOSED = "DISPOSED"}

View.static.STATES = STATES

function View:initialize()
	self.states = STATES
	self.state = STATES.DISPOSED
end

function View:bind_vh()

end

function View:create(root_node_name)
	assert(not self.root, "view already created")
	assert(self.state == STATES.DISPOSED)
	self.root_node_name = root_node_name
	self.root = assert(gui.get_node(root_node_name))
	self:bind_vh()
	self.state = STATES.HIDE
	self.scheduler = RX.CooperativeScheduler.create()
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

return View