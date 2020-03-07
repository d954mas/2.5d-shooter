local COMMON = require("libs.common")
local GA = require "libs.google_analytics"

local SceneBase = require "libs.sm.scene"

---@class SceneGA:Scene
local Scene = COMMON.class('SceneGA', SceneBase)



function Scene:show(...)
	SceneBase.show(self, ...)
	self._analytics_time = os.time()
	GA.event("scene", "show", self._name)
	GA.screenview(self._name)
end

function Scene:hide(...)
	SceneBase.hide(self, ...)
	self:send_timing()
end

function Scene:send_timing()
	if (self._analytics_time) then
		local timing = os.time() - self._analytics_time
		self._analytics_time = nil
		GA.event("scene", "hide", self._name)
		GA.timing("scene", self._name, timing)
	end
end


return Scene