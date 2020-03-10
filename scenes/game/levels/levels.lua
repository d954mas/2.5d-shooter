local COMMON = require "libs.common"
local Level = require "model.battle.level.level"
local JSON = require "libs.json"
local M = {}
local TAG = "LEVEL"

M.TESTS = {
	MOVEMENT = "test_movement",
	OBJECTS = "test_objects",
	PARSER = "test_parser_objects",
}

M.LEVELS = {
	TEST = "test_level"
}

function M.load_level(name)
	local time = os.clock()
	local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json", "no lvl:" .. name))
	local level = Level(JSON.decode(data))
	COMMON.d("lvl:" .. name .. " loaded. Time:" .. (os.clock() - time), TAG)
	return level
end

return M