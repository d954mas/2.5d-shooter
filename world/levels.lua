local COMMON = require "libs.common"
local M = {}
local TAG = "LEVEL"


M.TEST_LEVEL = "lvl_test"

---@class Level
local Level = COMMON.class("Level")

function Level:initialize(data)
	---@type LevelData
	self.data = assert(data)
end

function M.load_level(name)
	local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json","no lvl:" .. name))
	local lvl = Level(json.decode(data))
	COMMON.d(TAG,"lvl:" .. name .. " loaded")
end



return COMMON.read_only(M)