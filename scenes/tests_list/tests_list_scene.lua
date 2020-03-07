local BaseScene = require "libs.sm.scene"

---@class TestsListScene:Scene
local Scene = BaseScene:subclass("TestsListScene")
function Scene:initialize()
    BaseScene.initialize(self, "TestsListScene", "/tests_list_scene#collectionproxy")
end

return Scene