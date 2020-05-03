local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class SelectObjectDoorSystem:ECSSystem
local System = ECS.system()
System.name = "SelectObjectDoorSystem"

---@param e Entity
function System:update(dt)
	local game = self.world.game
	local result = game:raycast(game.player, 1, physics3d.GROUPS.OBSTACLE)
	local object = result[1]
	local ctx = COMMON.CONTEXT:set_context_game_gui()
	--ctx.data:action_info_set_visible(false)
	if (object) then
		local e = object.body:get_user_data()
		if (e.door and e.door_data.closed) then
			game:select_object(e)
		end
	end
	ctx:remove()
end

return System