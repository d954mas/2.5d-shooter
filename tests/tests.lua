local DEFTEST = require "tests.deftest.deftest"
local TEST_PARSER = require "tests.test_parser"
local TEST_LEVELS_LOADING = require "tests.test_levels_loading"
local TEST_PATHFINDING = require "tests.test_pathfinding"
local TEST_COLORS = require "tests.test_colors"

DEFTEST.add(TEST_PARSER)
DEFTEST.add(TEST_LEVELS_LOADING)
DEFTEST.add(TEST_PATHFINDING)
DEFTEST.add(TEST_COLORS)

local M = {}
function M.run()
	DEFTEST.run()
end

function M.update(dt)
	if DEFTEST.co and coroutine.status(DEFTEST.co)~="dead" then
		DEFTEST.continue(dt)
	end
end

return M