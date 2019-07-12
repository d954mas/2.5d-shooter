local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local CURSOR_HELPER = require "libs.cursor_helper"
local SM = require "libs.sm.sm"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end

function Scene:on_show()
    GAME_CONTROLLER:load_level(assert(self._input.level,"need level name"))
    CURSOR_HELPER.lock_cursor()
    CURSOR_HELPER.register_listeners()
    COMMON.input_acquire()
end

function Scene:on_hide()
    CURSOR_HELPER.unregister_listener()
    CURSOR_HELPER.unlock_cursor()
    COMMON.input_release()
end

function Scene:on_final(go_self)
    GAME_CONTROLLER:dispose()
end

function Scene:on_update(dt)
    self.dt = dt
    BaseScene.on_update(self,dt)
    GAME_CONTROLLER:update(dt)
    CURSOR_HELPER.update_cursor_movement()
    msg.post("#",COMMON.HASHES.MSG_POST_UPDATE)
end

function Scene:on_resume()
    GAME_CONTROLLER:on_resume()
end

--show pause modal if user unlock cursor. Press esc
function Scene:check_pause_modal()
    if not CURSOR_HELPER:is_locked() and not SM:is_loading() and not SM:is_show_modal("PauseModal") then
        SM:show("PauseModal",nil) --use delay of will see empty walls in html
    end
end

function Scene:on_input(action_id, action)
    CURSOR_HELPER.on_input(action_id,action)
    return GAME_CONTROLLER:on_input(action_id,action)
end

function Scene:on_message(message_id, message, sender)
    if message_id == COMMON.HASHES.MSG_POST_UPDATE then
        GAME_CONTROLLER:post_update(self.dt)
        self:check_pause_modal()
    end
end


function Scene:on_transition(transition)
end

return Scene