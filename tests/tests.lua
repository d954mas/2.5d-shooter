local DEFTEST = require "tests.deftest.deftest"
local TEST_PATHFINDING = require "tests.test_pathfinding"
local LEVELS_LOADING = require "tests.test_levels_loading"

DEFTEST.add(TEST_PATHFINDING)
DEFTEST.add(LEVELS_LOADING)



local M = {}
function M.run()
	DEFTEST.run()
end

function M.update()
	if DEFTEST.co and coroutine.status(DEFTEST.co)~="dead" then
		DEFTEST.continue()
	end
end

return M