local COMMON = require "libs.common"
local EVENTS = require "libs_project.events"
local CAMERAS = require "libs_project.cameras"

local Camera = COMMON.class("NativeCamera")

function Camera:initialize(rays, max_distance)
	checks("?", "number", "number")
	self.rays = rays
	self.max_distance = max_distance
	self.camera = native_raycasting.camera_new()
	self.camera:set_rays(self.rays)
	self.camera:set_max_dist(self.max_distance)
	self.subscription = COMMON.EVENT_BUS:subscribe(EVENTS.WINDOW_RESIZED):subscribe(function()
		self:camera_update_fov()
	end)
	self:camera_update_fov()
end

function Camera:final()
	if (self.subscription) then self.subscription:unsubscribe() end
	native_raycasting.camera_delete(self.camera)
	self.camera = nil
	self.subscription = nil
end

function Camera:camera_update_fov()
	local aspect = COMMON.RENDER.screen_size.w /  COMMON.RENDER.screen_size.h
	local v_fov = assert(CAMERAS.current, "no active camera").fov
	assert(v_fov,"no fov in camera")
	local h_fov = 2 * math.atan(math.tan(v_fov / 2) * aspect);
	self.camera:set_fov(h_fov * 1.2)
	--self.camera:set_fov(math.pi)
end

return Camera