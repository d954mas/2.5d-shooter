local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class ActionOpenDoorActionSystem:ECSSystem
local System = ECS.system()
System.name = "ActionOpenDoorActionSystem"

---@param e Entity
function System:update(dt)
	local game = self.world.game
	local result = game:raycast(game.player, 1, physics3d.GROUPS.OBSTACLE)
	local object = result[1]
	local ctx = COMMON.CONTEXT:set_context_game_gui()
	ctx.data:action_info_set_visible(false)
	if(object) then
		local e = object.body:get_user_data()
		if(e.door) then
			ctx.data:action_info_set_visible(true)
		end
	end
	ctx:remove()
end

return System