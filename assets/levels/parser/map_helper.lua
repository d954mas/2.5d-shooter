local LUME = require "libs.lume"

local M = {}

---@param map LevelData
function M.coords_to_id(map, x, y)
	return y * map.size.x + x
end

return M