local COMMON = require "libs.common"
local Level = require "model.battle.level.level"
local JSON = require "libs.json"
local M = {}
local TAG = "LEVEL"

M.TESTS = {
	TEST = "test_level",
	TEST_BIG_EMPTY = "test_level_big_empty",
	TEST_LIGHTS = "test_level_lights"
}

M.LEVELS = {
	LEVEL_1 = "level_1"
}

local function array_to_zero(array,max_id)
	for i = 1, max_id+1 do
		local str = tostring(i)
		if(array[str])then
			array[i - 1] = array[str]
			array[str] = nil
		else
			array[i - 1] = array[i]
		end

		if(array[i-1] == cjson.null) then array[i-1] = nil end
		--if array have empty it will be map in lua side.
	end
end

function M.load_level(name)
	local time = os.clock()
	local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json", "no lvl:" .. name))
	---@type LevelData
	local level_data = JSON.decode(data)
	local max_id = level_data.size.x * level_data.size.y - 1
	array_to_zero(level_data.walls,max_id)
	array_to_zero(level_data.ceil,max_id)
	array_to_zero(level_data.floor,max_id)
	local level = Level(level_data)
	COMMON.d("lvl:" .. name .. " loaded. Time:" .. (os.clock() - time), TAG)
	return level
end

return M