local GOOEY = require "gooey.gooey"
local M = {}

M.Button = require "assets.templates.button"

local btn_scale_refresh = function(button)
	if not button.scale_default then
		button.scale_default = gui.get_scale(button.node)
	end
	if button.pressed then
		gui.set_scale(button.node, button.scale_default * 0.9)
	else
		gui.set_scale(button.node, button.scale_default)
	end
end

local btn_base_refresh = function(button, base_img, on_img)
	if button.pressed then
		gui.play_flipbook(button.node, on_img)
	else
		gui.play_flipbook(button.node, base_img)
	end
end

function M.btn_scale(node, action_id, action, fn)
	GOOEY.button(node, action_id, action, fn, btn_scale_refresh)
end

function M.btn_create_base_refresh_f(node_name, config, fn)
	assert(node_name)
	assert(config)
	assert(fn)
	assert(config.base_img)
	assert(config.on_img)

	local refresh = function(button)
		btn_base_refresh(button, config.base_img, config.on_img)
	end

	return function(action_id, action)
		GOOEY.button(node_name, action_id, action, fn, refresh)
	end

end

return M
