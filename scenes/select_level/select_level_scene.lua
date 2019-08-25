local BaseScene = require "libs.sm.scene"

---@class SelectLevelScene:Scene
local Scene = BaseScene:subclass("SelectLevelScene")
function Scene:initialize()
    BaseScene.initialize(self, "SelectLevelScene", "/select_level#proxy", "select_level:/scene_controller")
end

return Scene