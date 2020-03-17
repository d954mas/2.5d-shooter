local COMMON = require "libs.common"
local NativeCamera = require "model.battle.native_camera"
local LightMap = require "model.battle.light_map"
local GameEcs = require "model.battle.ecs.game_ecs"
local LevelCreator = require "model.battle.level_creator"

---@class BattleModel
local Model = COMMON.class("BattleModel")

---@param world World
---@param level Level
function Model:initialize(world, level)
	self.world = assert(world)
	self.level = assert(level)
	self.time = 0

	self.light_map = LightMap(128)
	native_raycasting.map_set(self.level.data)
	self.ecs = GameEcs(self.world)
end

function Model:on_scene_show()
	if (not self.inited) then
		self.inited = true
		self.native_camera = NativeCamera(512, 50)
		self.light_map:set_level(self.level)
		self.ecs:load_level()
		LevelCreator(self.world):create()
	end

end

function Model:update(dt)
	self.time = self.time + dt
	if (self.inited) then
		self.ecs:update(dt)
	end
end

function Model:on_input(action, action_id) end

function Model:final()
	if self.native_camera then self.native_camera:final() end
	if self.light_map then self.light_map:final() end
	if self.ecs then self.ecs:clear() end
	self.native_camera = nil
	self.inited = false
	self.light_map = nil
	self.ecs = nil
	self.level = nil
end

return Model