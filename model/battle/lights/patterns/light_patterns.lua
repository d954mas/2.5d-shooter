local M = {}

M.Pattern1 = require "model.battle.lights.patterns.light_pattern_1"

---@return LightPattern
function M.get_by_id(id)
	local pattern = assert(M[id], "no pattern with id:" .. id)
	return pattern
end

return M