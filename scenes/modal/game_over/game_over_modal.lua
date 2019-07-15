local BaseScene = require "libs.sm.scene"

---@class GameOverModal:Scene
local Scene = BaseScene:subclass("GameOverModal")
function Scene:initialize()
    BaseScene.initialize(self, "GameOverModal", "/game_over_modal#proxy", "game_over_modal:/scene_controller")
    self._config.modal = true
end

function Scene:on_final()
end

function Scene:on_update(dt)
end


return Scene