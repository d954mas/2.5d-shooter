local COMMON = require "libs.common"
local WORLD = require "model.world"
local CURSOR_HELPER = require "libs_project.cursor_helper"
local Levels = require "scenes.game.levels.levels"
local BaseScene = require "libs.sm.scene"


---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
	BaseScene.initialize(self, "GameScene", "/game_scene#collectionproxy")
end

function Scene:load_done()
	assert(self._input, "GameScene need input")
	assert(self._input.level_id, "need level id")
	self.level = Levels.load_level(self._input.level_id)
	self.sm = requiref "libs_project.sm"
	WORLD:battle_set_level(self.level)
end

function Scene:show_done()
	WORLD.battle_model:on_scene_show()
	CURSOR_HELPER.register_listeners()

end

function Scene:hide_done()
	CURSOR_HELPER.unregister_listener()
end

function Scene:pause_done()
	CURSOR_HELPER.unlock_cursor()
end

function Scene:resume_done()
	CURSOR_HELPER.lock_cursor()
end


function Scene:update(dt)
	CURSOR_HELPER.update_cursor_movement()
end

function Scene:on_input(action_id, action)
	CURSOR_HELPER.on_input(action_id,action)
	if action_id == COMMON.HASHES.INPUT.ESK and action.released then
		self.sm:show(self.sm.MODALS.PAUSE)
	end
end

function Scene:unload_done()
	self.level = nil
end

return Scene