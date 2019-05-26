local M = {}

function M.get_scaled_size(node)
	assert(node)
	local size = gui.get_size(node)
	local scale = gui.get_scale(node)
	size.x = size.x * scale.x
	size.y = size.y * scale.y
	size.z = size.z * scale.z
	return size
end

return M