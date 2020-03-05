local CLASS = require "libs.middleclass"
local RX = require "libs.rx"
local LOG = require "libs.log"

local M = CLASS.class("EventBus")
local TAG = "EVENT_BUS"

function M:initialize()
	self.subject = RX.Subject.create()
end

---@return Subject
function M:subscribe(name)
	assert(name)
	return self.subject:filter(function(event) return event.name == name end)
end

function M:event(name, data)
	assert(name)
	if not data then data = {} end
	assert(not data.name)
	data.name = name
	LOG.i("event:" .. name, TAG)
	self.subject:onNext(data)
end

return M