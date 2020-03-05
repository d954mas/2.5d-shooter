local DEFTEST = require "tests.deftest.deftest"


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