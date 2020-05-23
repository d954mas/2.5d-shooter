local COMMON = require "libs.common"
local EVENTS = require "libs_project.events"
local Camera = require "rendercam.rendercam_camera"

local Cameras = COMMON.class("Cameras")

function Cameras:initialize()

end

function Cameras:init()
	self.game_camera = Camera("game", {
		orthographic = false,
		near_z = 0.1,
		far_z = 1000,
		view_distance = 0,
		fov = 60,
		ortho_scale = 1,
		fixed_aspect_ratio = false,
		aspect_ratio = vmath.vector3(1920, 1080, 0),
		use_view_area = false,
		view_area = vmath.vector3(1920, 1080, 0),
		scale_mode = Camera.SCALEMODE.FIXEDHEIGHT
	})

	self.fallback_camera = Camera("game", {
		orthographic = true,
		near_z = -1,
		far_z = 1,
		view_distance = 0,
		fov = 60,
		ortho_scale = 1,
		fixed_aspect_ratio = false,
		aspect_ratio = vmath.vector3(1920, 1080, 0),
		use_view_area = false,
		view_area = vmath.vector3(1920, 1080, 0),
		scale_mode = Camera.SCALEMODE.EXPANDVIEW
	})
	self.subscription = COMMON.EVENT_BUS:subscribe(EVENTS.WINDOW_RESIZED):subscribe(function()
		self:window_resized()
	end)

	self.current = self.fallback_camera
	self:window_resized()
end

function Cameras:update(dt)
	self.fallback_camera:update(dt)
	self.game_camera:update(dt)
end

function Cameras:set_current(camera)
	self.current = assert(camera)
end

function Cameras:set_fallback()
	self.current = self.fallback_camera
end

function Cameras:window_resized()
	self.game_camera:recalculate_viewport()
end

function Cameras:final()
	self.subscription:unsubscribe()
end

return Cameras