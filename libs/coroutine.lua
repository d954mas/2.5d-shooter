local M = {}
local LOG = require "libs.log"

---@return coroutine|nil return coroutine if it can be resumed(no errors and not dead)
function M.coroutine_resume(cor, ...)
	local ok, res = coroutine.resume(cor, ...)
	if not ok then
		LOG.e(res .. debug.traceback(cor, "", 1), "Error in coroutine", 1)
	else
		return not (coroutine.status(cor) == "dead") and cor
	end
end

function M.coroutine_wait(time)
	assert(time)
	local dt = 0
	while dt < time do
		dt = dt + coroutine.yield()
	end
end

return M