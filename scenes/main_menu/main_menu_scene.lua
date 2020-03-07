local BaseScene = require "libs.sm.scene"

---@class SelectLevelScene:Scene
local Scene = BaseScene:subclass("MainMenu")
function Scene:initialize()
    BaseScene.initialize(self, "MainMenuScene", "/main_menu_scene#collectionproxy")
end

return Scene