local BaseScene = require "libs.sm.scene"

---@class PauseModal:Scene
local Scene = BaseScene:subclass("PauseModal")
function Scene:initialize()
    BaseScene.initialize(self, "PauseModal", "/pause_modal#proxy", "pause_modal:/scene_controller")
    self._config.modal = true
end

function Scene:on_final(go_self)
end

function Scene:on_update(dt)
end


return Scene