local M = {}

M.Pattern1 = require "model.battle.lights.patterns.light_pattern_1"
M.Pattern2 = require "model.battle.lights.patterns.light_pattern_2"
M.Pattern3 = require "model.battle.lights.patterns.light_pattern_3"

---@return LightPattern
function M.get_by_id(id)
	local pattern = assert(M[id], "no pattern with id:" .. id)
	return pattern
end

return M