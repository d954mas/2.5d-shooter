local COMMON = require "libs.common"
local RX = require "libs.rx"
local STATE = require "world.state.state"
local TAG = "World"
local RESET_SAVE = false
local LEVELS = require "world.levels"

---@class World:Observable
local M = COMMON.class("World")

function M:reset()
end

function M:initialize()
	self.rx = RX.Subject()
	self.state = STATE
	self.autosave = true
	self.autosave_dt = 0
	self.autosave_time = 5
	self:reset()
end

function M:load_level(name)
	assert(not self.level,"lvl alredy loaded")
	self.level = LEVELS.load_level(name)
end


function M:update(dt)
	self:process_autosave(dt)
end

function M:process_autosave(dt)
	if self.autosave then
		self.autosave_dt = self.autosave_dt + dt
		if self.autosave_dt > self.autosave_time then
			self.autosave_dt = 0
			self:save()
		end
	end
end


function M:save()
	local state =  self.state:save()
	--COMMON.i("save state",TAG)--pprint(state)
	sys.save(sys.get_save_file("world","data"),  {state = self.state:save()})
end

function M:load()
	local data =  RESET_SAVE and {} or sys.load(sys.get_save_file("world", "data"))
	if not data.state then
		self.state:init_default()
		return
	end
	COMMON.i("load state",TAG)
	pprint(data.state)
	self.state:load(data.state,self)
end

function M:dispose()
	self:reset()
end

return M()