local COMMON = require "libs.common"
local EVENTS = require "libs_project.events"
local RENDER_CAM = require "rendercam.rendercam"

local Camera = COMMON.class("NativeCamera")

function Camera:initialize(rays, max_distance)
	checks("?", "number", "number")
	self.rays = rays
	self.max_distance = max_distance

	native_raycasting.camera_set_rays(self.rays)
	native_raycasting.camera_set_max_distance(self.max_distance)
	self.subscription = COMMON.EVENT_BUS:subscribe(EVENTS.WINDOW_RESIZED):subscribe(function()
		self:camera_update_fov()
	end)
	self:camera_update_fov()
end

function Camera:final()
	if (self.subscription) then self.subscription:unsubscribe() end
	self.subscription = nil
end

function Camera:camera_update_fov()
	local aspect = RENDER_CAM.window.x / RENDER_CAM.window.y
	local v_fov = assert(RENDER_CAM.get_current_camera(), "no active camera").fov
	assert(v_fov,"no fov in camera")
	local h_fov = 2 * math.atan(math.tan(v_fov / 2) * aspect);
	native_raycasting.camera_set_fov(h_fov * 1.2) --use bigger fov then visible
end

return Camera