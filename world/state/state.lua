local COMMON = require "libs.common"
local LUME = require "libs.lume"


local VERSION = 11

---@class State
---@field __VALUE State
local M = {}

function M:init_default()
	self = self.__VALUE or self
	self.current_stage = 1
	self.user = {
		exp = 0,
		lvl = 1,
	}
	self.resources = {
		souls = 0,
		gems = 0,
		gold = 0
	}
	self.attributes = {
		power = 5,
		agility = 5,
		constitution = 5
	}
end

function M:load(t,world)
	if t.version < VERSION then
		self:init_default()
		return
	end
	self = self.__VALUE or self
	self.user = {
		exp = assert(t.user.exp),
		lvl = assert(t.user.lvl)
	}
	self.resources = {
		souls = assert(t.resources.souls),
		gems = assert(t.resources.gems),
		gold = assert(t.resources.gold),
	}
	self.attributes = {
		power =  assert(t.attributes.power),
		agility =  assert(t.attributes.agility),
		constitution =  assert(t.attributes.constitution),
	}
end

function M:save()
	self = self or self.__VALUE
	local t = {}
	t.current_stage = M.current_stage
	t.resources = LUME.clone(self.resources)
	t.user = LUME.clone(self.user)
	t.attributes = LUME.clone(self.attributes)
	t.version = VERSION
	return t
end

return COMMON.read_only(M)