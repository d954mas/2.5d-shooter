local COMMON = require "libs.common"
local LUME = require "libs.lume"

---@class UpdatedLabel
local Lbl = COMMON.class("UpdatedLabel")


function Lbl:initialize(lbl)
	self.lbl = assert(lbl, "model can't be nil")
	self.prev_value = 0
	self.current_value = 0
	self.next_value = 0
	self.tick_time = 1
end

function Lbl:set_tick_time(time)
	self.tick_time = assert(time)
end

function Lbl:set_value(value, force)
	assert(type(value)== "number")
	self.next_value = value
	self.prev_value = self.current_value
	self.time = 0
	if force then
		self.prev_value = self.next_value
		self.current_value = self.next_value
		gui.set_text(self.lbl, math.floor(self.current_value))
	end
end

function Lbl:update(dt)
	if self.current_value ~= self.next_value then
		self.time = self.time + dt
		self.current_value = LUME.lerp(self.prev_value, self.next_value, self.time/self.tick_time)
		gui.set_text(self.lbl, math.floor(self.current_value))
	end
end


return Lbl
