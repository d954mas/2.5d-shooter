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

local function array_to_zero(array)
	for i = 1, #array do
		array[i - 1] = array[i]
	end
end



function M.load_level(name)
	local time = os.clock()
	local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json", "no lvl:" .. name))
	---@type LevelData
	local level_data = JSON.decode(data)
	array_to_zero(level_data.walls)
	array_to_zero(level_data.ceil)
	array_to_zero(level_data.floor)
	local level = Level(level_data)
	COMMON.d("lvl:" .. name .. " loaded. Time:" .. (os.clock() - time), TAG)
	return level
end

return M