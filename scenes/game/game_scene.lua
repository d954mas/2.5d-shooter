local BaseScene = require "libs.sm.scene"
local Levels = require "scenes.game.levels.levels"
local WORLD = require "model.world"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
	BaseScene.initialize(self, "GameScene", "/game_scene#collectionproxy")
end

function Scene:load_done()
	assert(self._input, "GameScene need input")
	assert(self._input.level_id, "need level id")
	self.level = Levels.load_level(self._input.level_id)
	WORLD:battle_set_level(self.level)
end

function Scene:show_done()
	WORLD.battle_model:on_scene_show()
end

function Scene:unload_done()
	WORLD:battle_model_final()
	self.level = nil
end

return Scene