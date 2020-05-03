local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class SelectObjectReset:ECSSystem
local System = ECS.system()
System.name = "SelectObjectReset"

---@param e Entity
function System:update(dt)
	self.world.game.selected_object = nil
end



return System