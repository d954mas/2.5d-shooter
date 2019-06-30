local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local WORLD = require "world.world"
local LEVELS = require "world.model.levels"
local CURSOR_HELPER = require "libs.cursor_helper"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end

function Scene:on_show(input)
    WORLD:load_level(assert(LEVELS.TESTS.LEVEL))
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
    WORLD:dispose()
end

function Scene:on_update(dt)
    self.dt = dt
    BaseScene.on_update(self,dt)
    WORLD:update(dt)
    CURSOR_HELPER.update_cursor_movement()
    msg.post("#",COMMON.HASHES.MSG_POST_UPDATE)
end

function Scene:on_input(action_id, action)
    if WORLD.level_view then
        WORLD.level_view:on_input(action_id,action)
    end
end

function Scene:on_message(message_id, message, sender)
    if message_id == COMMON.HASHES.MSG_POST_UPDATE then
        WORLD:post_update(self.dt)
    end
end


function Scene:on_transition(transition)
end

return Scene