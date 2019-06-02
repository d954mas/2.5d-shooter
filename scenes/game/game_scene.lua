local BaseScene = require "libs.sm.scene"
local SM = require "libs.sm.sm"
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
    WORLD:load_level(assert(LEVELS.TEST_LEVEL))
    CURSOR_HELPER.lock_cursor()
    CURSOR_HELPER.register_listeners()
    COMMON.input_acquire()
end

function Scene:on_hide()
    CURSOR_HELPER.unregister_listener()
    CURSOR_HELPER.unlock_cursor()
    COMMON.input_release()

end

function Scene:final(go_self)
end

function Scene:on_update(dt)
    BaseScene.on_update(self,dt)
    WORLD:update(dt)
    CURSOR_HELPER.check()
end

function Scene:on_input(action_id, action)

end


function Scene:on_transition(transition)
end

return Scene