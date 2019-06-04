local COMMON = require "libs.common"
local Level = require "world.model.level"
local M = {}
local TAG = "LEVEL"


M.TEST_LEVEL = "lvl_test"


---@return Level
function M.load_level(name)
	local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json","no lvl:" .. name))
	local lvl = Level(json.decode(data))
	COMMON.d(TAG,"lvl:" .. name .. " loaded")
	return lvl
end



return COMMON.read_only(M)