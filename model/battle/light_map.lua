local COMMON = require "libs.common"

local LightMap = COMMON.class("LightMap")

local HASH_LIGHT_MAP = hash("light_map")


--draw all ambient light of level to texture
--if level bigger then size there will be problems
function LightMap:initialize(size)
	checks("?", "number")
	self.size = size
	self.buffer = buffer.create(self.size * self.size, { { name = HASH_LIGHT_MAP, type = buffer.VALUE_TYPE_UINT8, count = 3 } })
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.RENDER)
	local render = COMMON.RENDER
	self.render_target = render:create_render_target(HASH_LIGHT_MAP, { w = size, h = size })
	render.targets.light_map = self.render_target
	render.constants_buffers.light_map.light_map = vmath.vector4(self.size, self.size, 0, 0)
	self:set_fog_color(vmath.vector4(0.15))
	self:set_fog(2, 0, 0.1)
	ctx:remove()
end

function LightMap:set_fog_color(color)
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.RENDER)
	COMMON.RENDER.constants_buffers.light_map.fog_color = color
	ctx:remove()
end

function LightMap:set_fog(start_dist, end_dist, exp)
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.RENDER)
	COMMON.RENDER.constants_buffers.light_map.fog = vmath.vector4(start_dist, end_dist, exp, 0) -- //x start distance y end dist. z exp
	ctx:remove()
end

---@param level Level
function LightMap:set_level(level)
	self.level = level
	self:set_colors(level.data.light_map)
end

function LightMap:set_colors(colors, base_colors)
	local w, h = self.level.data.size.x, self.level.data.size.y
	native_raycasting.light_map_set_colors(self.buffer, self.size, w, h, colors, base_colors or {})
	self:on_changed()
end

function LightMap:on_changed()
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.LIGHT_MAP_SCRIPT)
	if (not self.go_resource_path) then
		self.go_resource_path = go.get("#model", "texture0")
		self.go_header = { width = self.size, height = self.size, type = resource.TEXTURE_TYPE_2D, format = resource.TEXTURE_FORMAT_RGB, num_mip_maps = 1 }
	end
	resource.set_texture(self.go_resource_path, self.go_header, self.buffer)
	ctx:remove()
end

--call it from render script
function LightMap:draw_light_map(debug)
	render.disable_state(render.STATE_DEPTH_TEST)
	render.disable_state(render.STATE_STENCIL_TEST)
	render.disable_state(render.STATE_CULL_FACE)
	if debug then
		local size = math.max(512, self.size)
		render.set_viewport(20, 20, size, size)
	else
		render.set_viewport(0, 0, self.size, self.size)
	end
	render.set_view(vmath.matrix4())
	render.set_projection(vmath.matrix4_orthographic(-0.01, 0.01, -0.01, 0.01, -1, 1))
	if not debug then
		render.enable_render_target(self.render_target)
		render.clear({ [render.BUFFER_COLOR_BIT] = vmath.vector4(1, 1, 1, 1), [render.BUFFER_DEPTH_BIT] = 1, [render.BUFFER_STENCIL_BIT] = 0 })
	end
	render.draw(COMMON.RENDER.predicates.light_map)
	if not debug then render.disable_render_target(self.render_target) end
end

function LightMap:final()
	local ctx = COMMON.CONTEXT:set_context_top_by_name(COMMON.CONTEXT.NAMES.RENDER)
	render.delete_render_target(self.render_target)
	COMMON.RENDER.targets.light_map = nil
	ctx:remove()
	self.buffer = nil
end

return LightMap