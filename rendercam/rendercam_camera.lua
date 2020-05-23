local COMMON = require "libs.common"
local PERLIN = require "libs.perlin"
local HASHES = require "libs.hashes"
local CHECKS = require "libs.checks"

PERLIN.init()

---@class Camera
local Camera = COMMON.class("camera")

Camera.SCALEMODE = {
	EXPANDVIEW = "expandView",
	FIXEDAREA = "fixedArea",
	FIXEDWIDTH = "fixedWidth",
	FIXEDHEIGHT = "fixedHeight",
}

Camera.GUI_ADJUST = {
	FIT = "fit",
	ZOOM = "zoom",
	STRETCH = "stretch"
}

---@class CameraConfig
local CameraConfig = {
	orthographic = "boolean",
	near_z = "number",
	far_z = "number",
	view_distance = "number",
	fov = "number",
	ortho_scale = "number",
	fixed_aspect_ratio = "boolean",
	aspect_ratio = "userdata", -- only used with a fixed aspect ratio
	use_view_area = "boolean",
	view_area = "userdata",
	scale_mode = "string",
}

local TWO_PI = math.pi * 2
local FORWARDVEC = vmath.vector3(0, 0, -1)
local UPVEC = vmath.vector3(0, 1, 0)
local RIGHTVEC = vmath.vector3(1, 0, 0)

local VMATH_ROTATE = vmath.rotate

local CAMERA_DEFAULTS = {
	orthographic = true,
	near_z = -1,
	far_z = 1,
	view_distance = 0,
	fov = -1,
	ortho_scale = 1,
	fixed_aspect_ratio = true,
	aspect_ratio = vmath.vector3(16, 9, 0), -- only used with a fixed aspect ratio

	use_view_area = false,
	view_area = vmath.vector3(800, 600, 0),

	scale_mode = Camera.SCALEMODE.EXPANDVIEW
}

---@param config CameraConfig
function Camera:initialize(id, config)
	config = COMMON.LUME.merge_table(CAMERA_DEFAULTS, config)
	checks("?", "string", CameraConfig)
	assert(config.scale_mode == Camera.SCALEMODE.EXPANDVIEW or config.scale_mode == Camera.SCALEMODE.FIXEDAREA
			or config.scale_mode == Camera.SCALEMODE.FIXEDHEIGHT or config.scale_mode == Camera.SCALEMODE.FIXEDWIDTH)
	self.config = config

	if not self.config.orthographic then
		assert(self.config.near_z > 0 and self.config.far_z > 0)
	end

	self.screen_size = { w = COMMON.RENDER.screen_size.w, h = COMMON.RENDER.screen_size.h }

	self.ortho_zoom_mult = 0.01
	self.follow_lerp_speed = 3

	-- Put all camera data into a table for rendercam module and init camera.
	self.id = assert(id)
	self.near_z = assert(self.config.near_z)
	self.far_z = assert(self.config.far_z)
	self.abs_near_z = assert(self.near_z)
	self.abs_far_z = assert(self.far_z)
	self.world_z = 0 -- self.wpos.z - self.viewDistance, -- worldZ only used for screen_to_world_2d
	self.orthographic = self.config.orthographic
	self.fov = assert(self.config.fov)
	self.fixed_aspect_ratio = self.config.fixed_aspect_ratio
	self.ortho_scale = assert(self.config.ortho_scale)
	self.aspect_ratio = assert(self.config.aspect_ratio)
	self.aspect_ratio_number = self.config.aspect_ratio.x / self.config.aspect_ratio.y
	self.scale_mode = assert(self.config.scale_mode)
	self.use_view_area = self.config.use_view_area
	self.view_area = assert(self.config.view_area)
	self.view_area_initial = vmath.vector3(self.view_area)
	self.half_view_area = vmath.vector3(self.view_area) * 0.5

	--local pos. Used for effets shake zoom rotation and etc
	self.lpos = vmath.vector3(0)
	self.lrot = vmath.quat_rotation_z(0)

	self.wpos = vmath.vector3(0)
	self.wrot = vmath.quat_rotation_z(0)

	self.lforward_vec = vmath.rotate(self.lrot, FORWARDVEC) -- for zooming
	self.lup_vec = vmath.rotate(self.lrot, UPVEC) -- or panning
	self.lright_vec = vmath.rotate(self.lrot, RIGHTVEC) -- for panning

	self.wforward_vec = vmath.rotate(self.wrot, FORWARDVEC) -- for calculating view matrix
	self.wup_vec = vmath.rotate(self.wrot, UPVEC) -- for calculating view matrix

	self.shake = vmath.vector3()
	self.follow_pos = vmath.vector3()

	self.shakes = {}
	self.recoils = {}
	self.follows = {}
	self.rotations = {}
	self.perlin_seeds = { math.random(256), math.random(256), math.random(256) }
	self.following = false

	if self.fixed_aspect_ratio then
		if self.use_view_area then
			-- aspectRatio overrides proportion of viewArea (uses viewArea.x)
			self.view_area.y = self.view_area.x / self.aspect_ratio_number
		else
			-- or get fixed aspect viewArea inside current window
			local scale = math.min(self.screen_size.w / self.aspect_ratio_number, self.screen_size.h / 1)
			self.view_area.x = scale * self.aspect_ratio_number;
			self.view_area.y = scale
		end
	elseif not self.useViewArea then
		-- not using viewArea and non-fixed aspect ratio
		-- Set viewArea to current window size
		self.view_area.x = self.screen_size.w;
		self.view_area.y = self.screen_size.h
	end

	self.view_area.z = self.config.view_distance
	-- viewArea.z only used (with viewArea.y) in rendercam.update_window to get the FOV

	-- Fixed FOV -- just have to set initial viewArea to match the FOV
	-- to -maintain- a fixed FOV, must use "Fixed Height" mode, or a fixed aspect ratio and any "Fixed" scale mode.
	if self.fov > 0 then
		self.fov = math.rad(self.fov) -- FOV is set in degrees
		if not self.orthographic and not self.use_view_area then -- don't use FOV if using view area
			if self.view_area.z == 0 then self.view_area.z = 1 end -- view distance doesn't matter for fixed FOV, it just can't be zero.
			self.view_area.y = (self.view_area.z * math.tan(self.fov * 0.5)) * 2
			if self.fixed_aspect_ratio then
				self.view_area.x = self.view_area.y * self.aspect_ratio_number
			end
		end
	end

	self.view = vmath.matrix4() -- current view matrix
	self.proj = vmath.matrix4() -- current proj matrix
	self.gui_proj = vmath.matrix4()
	self.viewport = { x = 0, y = 0, width = self.screen_size.w, height = self.screen_size.h, scale = { x = 1, y = 1 } }

	-- GUI "transform" data - set in `calculate_gui_adjust_data` and used for screen-to-gui transforms in multiple places
	--				Fit		(scale)		(offset)	Zoom						Stretch
	self.gui_adjust = { [Camera.GUI_ADJUST.FIT] = { sx = 1, sy = 1, ox = 0, oy = 0 }, [Camera.GUI_ADJUST.ZOOM] = { sx = 1, sy = 1, ox = 0, oy = 0 }, [Camera.GUI_ADJUST.STRETCH] = { sx = 1, sy = 1, ox = 0, oy = 0 } }
	self.gui_offset = vmath.vector3()

	self.dirty = true
end

function Camera:follow_lerp_func(curPos, targetPos, dt)
	return vmath.lerp(dt * self.follow_lerp_speed, curPos, targetPos)
end

function Camera:update(dt)
	local prev_shake = vmath.vector3(self.shake)
	self.shake.x = 0;
	self.shake.y = 0;
	self.shake.z = 0
	for i = #self.shakes, 1, -1 do
		-- iterate backwards so I can remove arbitrary elements without problems
		local v = self.shakes[i]
		local d = math.random() * v.dist * v.t / v.dur -- linear falloff
		local angle = math.random() * TWO_PI
		self.shake = self.shake + self.lright_vec * math.sin(angle) * d
		self.shake = self.shake + self.lup_vec * math.cos(angle) * d
		v.t = v.t - self.dt
		if v.t <= 0 then table.remove(self.shakes, i) end
	end

	-- Camera Recoil
	for i = #self.recoils, 1, -1 do
		local v = self.recoils[i]
		local d = v.t / v.dur
		d = d * d -- square falloff
		self.shake = self.shake + vmath.rotate(self.lrot, v.vec * d) -- rotate recoil vec so it's relative to the camera
		v.t = v.t - self.dt
		if v.t <= 0 then table.remove(self.recoils, i) end
	end

	self.dirty = self.dirty or prev_shake ~= self.shake

	local prev_follow_pos = vmath.vector3(self.follow_pos)
	-- Camera Follow
	if self.following then
		self.follow_pos.x = 0;
		self.follow_pos.y = 0;
		for i, v in ipairs(self.follows) do
			self.follow_pos = self.follow_pos + go.get_world_position(v)
		end
		self.follow_pos = self.follow_pos * (1 / #self.follows)
		self.follow_pos = self:follow_lerp_func(self.data.lpos, self.follow_pos, self.dt)
		self.data.lpos.x = self.followPos.x;
		self.data.lpos.y = self.followPos.y
	end
	self.dirty = self.dirty or prev_follow_pos ~= self.follow_pos

	--self.data.lpos = self.data.lpos + self.shake

	--Camera Rotation
	--[[if self.data.rotations[1] then
		if self.dt ~= 0 then
			self.dt = self.dt
			local rotation = self.data.rotations[1]
			local time = os.clock()
			local shake = rotation.trauma * rotation.trauma
			local up = rotation.value.x  * shake * (PERLIN.noise(time*7,0,self.data.perlin_seeds[1]))
			local right =rotation.value.y * shake * (PERLIN.noise(time*7,0,self.data.perlin_seeds[2]))
			local around = rotation.value.z * shake * (PERLIN.noise(time*7,0,self.data.perlin_seeds[3]))

			rotation.trauma = rotation.trauma - rotation.speed * self.dt
			if rotation.trauma <= 0 then table.remove(self.data.rotations, 1) end

			local rot_x = vmath.quat_rotation_x(up)
			local rot_y = vmath.quat_rotation_y(right)
			local rot_z = vmath.quat_rotation_z(around)
			self.prev_rotation = rot_x * rot_y * rot_z
		end

		self.wrot = self.wrot * self.prev_rotation
	end--]]
end

function Camera:set_position(pos)
	if (self.wpos.x ~= pos.x or self.wpos.y ~= pos.y or self.wpos.z ~= pos.z) then
		self.wpos.x, self.wpos.y, self.wpos.z = pos.x, pos.y, pos.z
		self.dirty = true
	end
end

function Camera:set_rotation(rot)
	if (self.wrot.x ~= rot.x or self.wrot.y ~= rot.y or self.wrot.z ~= rot.z or self.wrot.w ~= rot.w) then
		self.wrot.x, self.wrot.y, self.wrot.z, self.wrot.w = rot.x, rot.y, rot.z, rot.w
		self.dirty = true
	end
end

function Camera:get_view()
	if (self.dirty) then
		self:recalculate_view_proj()
	end
	return self.view
end

function Camera:get_proj()
	if (self.dirty) then
		self:recalculate_view_proj()
	end
	return self.proj
end

function Camera:get_gui_proj()
	return self.gui_proj
end

function Camera:recalculate_view_proj()
--	print("camera:" .. self.id .. " recalculate_view_proj")
	self.dirty = false
	--recalculate all
	self.wforward_vec = VMATH_ROTATE(self.wrot, FORWARDVEC)
	self.wup_vec = VMATH_ROTATE(self.wrot, UPVEC)
	-- Absolute/world near and far positions for screen-to-world transform
	self.abs_near_z = self.wpos.z - self.near_z
	self.abs_far_z = self.wpos.z - self.far_z

	self.view = vmath.matrix4_look_at(self.wpos, self.wpos + self.wforward_vec, self.wup_vec)

	if (self.orthographic) then
		local x = self.half_view_area.x * self.ortho_scale
		local y = self.half_view_area.y * self.ortho_scale
		self.proj = vmath.matrix4_orthographic(-x, x, -y, y, self.near_z, self.far_z)
	else
		self.proj = vmath.matrix4_perspective(self.fov, self.aspect_ratio_number, self.near_z, self.far_z)
	end
end

function Camera:get_target_worldViewSize(lastX, lastY, lastWinX, lastWinY, winX, winY)
	local x, y
	if self.fixed_aspect_ratio then
		if self.scale_mode == Camera.SCALEMODE.EXPANDVIEW then
			local z = math.max(lastX / lastWinX, lastY / lastWinY)
			x, y = winX * z, winY * z
		else
			-- Fixed Area, Fixed Width, and Fixed Height all work the same with a fixed aspect ratio
			--		The proportion and world view area remain the same.
			x, y = lastX, lastY
		end
		-- Enforce aspect ratio
		local scale = math.min(x / self.aspect_ratio_number, y / 1)
		x, y = scale * self.aspect_ratio_number, scale
	else
		-- Non-fixed aspect ratio
		if self.scale_mode == Camera.SCALEMODE.EXPANDVIEW then
			local z = math.max(lastX / lastWinX, lastY / lastWinY)
			x, y = winX * z, winY * z
		elseif self.scale_mode == Camera.SCALEMODE.FIXEDAREA then
			local aspect = winX / winY
			local view_area_aspect = self.view_area_initial.x / self.view_area_initial.y
			if aspect >= view_area_aspect then
				x, y = self.view_area_initial.y * aspect, self.view_area_initial.y
			else
				x, y = self.view_area_initial.x, self.view_area_initial.x / aspect
			end
		elseif self.scale_mode == Camera.SCALEMODE.FIXEDWIDTH then
			local ratio = winX / winY
			x, y = lastX, lastX / ratio
		elseif self.scale_mode == Camera.SCALEMODE.FIXEDHEIGHT then
			local ratio = winX / winY
			x, y = lastY * ratio, lastY
		else
			error("rendercam - get_target_worldViewSize() - camera:  scale mode not found.")
		end
	end

	return x, y
end

function Camera:recalculate_viewport()
--	print("camera:" .. self.id .. " recalculate_viewport")
	local new_x = COMMON.RENDER.screen_size.w
	local new_y = COMMON.RENDER.screen_size.h

	local x, y = self:get_target_worldViewSize(self.view_area.x, self.view_area.y, self.screen_size.w, self.screen_size.h, new_x, new_y)
	self.view_area.x = x;
	self.view_area.y = y
	self.aspect_ratio = x / y
	self.screen_size.w = new_x
	self.screen_size.h = new_y
	self.viewport.width = x;
	self.viewport.height = y -- if using a fixed aspect ratio this will be immediately overwritten

	if self.fixed_aspect_ratio then
		-- if fixed aspect ratio, calculate viewport cropping
		local scale = math.min(self.screen_size.w / self.aspect_ratio_number, self.screen_size.h / 1)
		self.viewport.width = self.aspect_ratio_number * scale
		self.viewport.height = scale

		-- Viewport offset: bar on edge of screen from fixed aspect ratio
		self.viewport.x = (self.screen_size.w - self.viewport.width) * 0.5
		self.viewport.y = (self.screen_size.h - self.viewport.height) * 0.5

		-- For screen-to-viewport coordinate conversion
		self.viewport.scale.x = self.viewport.width / new_x
		self.viewport.scale.y = self.viewport.height / new_y
	else
		self.viewport.x = 0;
		self.viewport.y = 0
		self.viewport.width = new_x;
		self.viewport.height = new_y
	end

	if self.orthographic then
		self.half_view_area.x = x / 2;
		self.half_view_area.y = y / 2
	else
		self.fov = self:fov_calculate(self.view_area.z, self.view_area.y * 0.5)
	end
	self:calculate_gui_adjust_data(self.screen_size.w, self.screen_size.h, COMMON.RENDER.config_size.w, COMMON.RENDER.config_size.h)
	self.gui_proj = vmath.matrix4_orthographic(0, self.screen_size.w, 0, self.screen_size.h, -1, 1)

	self.dirty = true
end

function Camera:fov_calculate(distance, y)
	-- must use Y, not X
	return math.atan(y / distance) * 2
end

function Camera:calculate_gui_adjust_data(winX, winY, configX, configY)
	local sx, sy = winX / configX, winY / configY

	-- Fit
	local adj = self.gui_adjust[Camera.GUI_ADJUST.FIT]
	local scale = math.min(sx, sy)
	adj.sx = scale;
	adj.sy = scale
	adj.ox = (winX - configX * adj.sx) * 0.5 / adj.sx
	adj.oy = (winY - configY * adj.sy) * 0.5 / adj.sy

	-- Zoom
	adj = self.gui_adjust[Camera.GUI_ADJUST.ZOOM]
	scale = math.max(sx, sy)
	adj.sx = scale;
	adj.sy = scale
	adj.ox = (winX - configX * adj.sx) * 0.5 / adj.sx
	adj.oy = (winY - configY * adj.sy) * 0.5 / adj.sy

	-- Stretch
	adj = self.gui_adjust[Camera.GUI_ADJUST.STRETCH]
	adj.sx = sx;
	adj.sy = sy
	-- distorts to fit window, offsets always zero
end

return Camera
