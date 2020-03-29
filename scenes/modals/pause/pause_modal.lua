local BaseScene = require "libs.sm.scene"

---@class PauseModal:Scene
local Scene = BaseScene:subclass("PauseModal")
function Scene:initialize()
	BaseScene.initialize(self, "PauseModal", "/pause_modal#collectionproxy", { modal = true })
end


return Scene