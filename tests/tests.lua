local DEFTEST = require "tests.deftest.deftest"
local TEST_PATHFINDING = require "tests.test_pathfinding"
local TEST_PARSER = require "tests.test_parser"
local TEST_LEVELS_LOADING = require "tests.test_levels_loading"
local TEST_WEAPONS = require "tests.test_weapons"
local TEST_PLAYER = require "tests.test_player"

DEFTEST.add(TEST_PARSER)
DEFTEST.add(TEST_LEVELS_LOADING)
DEFTEST.add(TEST_PATHFINDING)
DEFTEST.add(TEST_PLAYER)
DEFTEST.add(TEST_WEAPONS)



local M = {}
function M.run()
	sys.set_error_handler(function (source,message,traceback)
		assert(nil,"game error:" .. message)
	end)
	DEFTEST.run()
end

function M.update(dt)
	if DEFTEST.co and coroutine.status(DEFTEST.co)~="dead" then
		DEFTEST.continue(dt)
	end
end

return M