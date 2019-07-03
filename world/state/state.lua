local COMMON = require "libs.common"
local LUME = require "libs.lume"


local VERSION = 1

---@class State
---@field __VALUE State
local M = {}

function M:init_default()
	self = self.__VALUE or self
end

function M:load(t,world)
	if t.version < VERSION then
		self:init_default()
		return
	end
	self = self.__VALUE or self
end

function M:save()
	self = self or self.__VALUE
	local t = {}
	return t
end

return COMMON.read_only(M)