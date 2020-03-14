local COMMON = require "libs.common"
local NativeCamera = require "model.battle.native_camera"
local LightMap = require "model.battle.light_map"
local GameEcs = require "model.battle.ecs.game_ecs"

---@class BattleModel
local Model = COMMON.class("BattleModel")

---@param world World
---@param level Level
function Model:initialize(world, level)
	self.world = assert(world)
	self.level = assert(level)
end

function Model:on_scene_show()
	if (not self.native_camera) then
		self.native_camera = NativeCamera(512, 50)
		self.light_map = LightMap(128)
		self.light_map:set_level(self.level)
		self.ecs = GameEcs(self.world)
	end
end

function Model:update(dt) end

function Model:on_input(action, action_id) end

function Model:final()
	if self.native_camera then self.native_camera:final() end
	if self.light_map then self.light_map:final() end
	if self.ecs then self.ecs:clear() end
	self.native_camera = nil
	self.light_map = nil
	self.ecs = nil
	self.level = nil
end

return Model