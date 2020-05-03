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
	if (object) then
		local e = object.body:get_user_data()
		local data = ctx.data
		if (e.door and e.door_data.closed) then
			data:action_info_set_visible(true)
			local have_key = false
			if (e.door_data.key) then
				if (have_key) then
					data.view.lbl_action:set_text(COMMON.LOCALE.door_open_press_key({ key = "<size=0.66><img=gui:key_e/></size>" }))
				else
					data.view.lbl_action:set_text(COMMON.LOCALE.door_open_need_key({ key = ("<size=0.66><img=gui:%s/></size>"):format("icon_key_" .. e.door_data.key) }))
				end
			else
				data.view.lbl_action:set_text(COMMON.LOCALE.door_open_press_key({ key = "<size=0.66><img=gui:key_e/></size>" }))
			end

		end
	end
	ctx:remove()
end

return System