local COMMON = require "libs.common"
local NativeCamera = require "model.battle.native_camera"

---@class BattleModel
local Model = COMMON.class("BattleModel")

---@param level Level
function Model:initialize(level)
	self.level = assert(level)
end

function Model:on_scene_show()
	if (not self.native_camera) then
		self.native_camera = NativeCamera(512, 50)
	end
end

function Model:update(dt) end

function Model:on_input(action, action_id) end

function Model:final()
	if self.native_camera then self.native_camera:final() end
	self.native_camera = nil
	self.level = nil
end

return Model