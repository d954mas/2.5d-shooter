local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class LightDynamicUpdateSystem:ECSSystem
local System = ECS.system()
System.name = "LightDynamicUpdateSystem"

---@param e Entity
function System:update(dt)
	local player = self.world.game.ecs.game.player
	self.world.game.world.battle_model.shader_lights:update_pos(player.position.x, player.position.y)
end

return System