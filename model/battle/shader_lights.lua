local COMMON = require "libs.common"

local HASH_SHADER_LIGHTS = hash("shader_lights")

local ShaderLights = COMMON.class("ShaderLights")

---@class ShaderLightsConfig
local ShaderLightsConfig = {
	size = "number",
	pixel_per_cell = "number"
}

---@param config ShaderLightsConfig
function ShaderLights:initialize(config)
	checks("?", ShaderLightsConfig)
	self.config = config
	self.buffer_lua = buffer.create(self.config.size * self.config.size * self.config.pixel_per_cell, { { name = HASH_SHADER_LIGHTS, type = buffer.VALUE_TYPE_UINT8, count = 3 } })
	self.buffer = native_raycasting.buffer_new(self.buffer_lua, self.config.size, self.config.size, 3)
	---@type World
	self.world = nil
end

---@param level Level
function ShaderLights:set_level(level)
	self.level = level
end

function ShaderLights:update_pos(x, y)
	x, y = math.floor(x), math.floor(y)
	local start_x, end_x = x - math.floor(self.config.size / 2), x + math.floor(self.config.size / 2) - 1
	local start_y, end_y = y - math.floor(self.config.size / 2), y + math.floor(self.config.size / 2) - 1
	start_x = COMMON.LUME.clamp(start_x, 0, self.level.data.size.x - 1)
	end_x = COMMON.LUME.clamp(end_x, 0, self.level.data.size.x - 1)
	start_y = COMMON.LUME.clamp(start_y, 0, self.level.data.size.y - 1)
	end_y = COMMON.LUME.clamp(end_y, 0, self.level.data.size.y - 1)

	for cell_y = start_y, end_y do
		for cell_x = start_x, end_x do
			local id = cell_y * self.config.size + cell_x
			local wall = native_raycasting.cells_get_by_id(self.level:coords_to_id(cell_x,cell_y))
			self.buffer:set_color(id, wall:get_blocked() and 0x000000 or 0xffffff)
		end
	end

	self:on_changed()
end

function ShaderLights:on_changed()
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.DYNAMIC_LIGHT)
	if (not self.go_header) then
		self.go_header = { width = self.config.size, height = self.config.size, type = resource.TEXTURE_TYPE_2D, format = resource.TEXTURE_FORMAT_RGB, num_mip_maps = 0 }
	end
	resource.set_texture(ctx.data.model0_texture_path, self.go_header, self.buffer_lua)
	ctx:remove()
end

--call it from render script
function ShaderLights:draw_debug_walls()
	render.disable_state(render.STATE_DEPTH_TEST)
	render.disable_state(render.STATE_STENCIL_TEST)
	render.disable_state(render.STATE_CULL_FACE)

	render.set_viewport(20, render.get_window_height()-128 - 10, 128, 128)

	render.set_view(vmath.matrix4())
	render.set_projection(vmath.matrix4_orthographic(-0.01, 0.01, -0.01, 0.01, -1, 1))
	render.draw(COMMON.RENDER.predicates.dynamic_light_walls)
end



function ShaderLights:final()
	native_raycasting.buffer_delete(self.buffer)
	self.buffer = nil
	self.buffer_lua = nil
end

return ShaderLights