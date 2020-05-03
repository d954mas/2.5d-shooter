local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class SelectObjectActionSystem:ECSSystem
local System = ECS.system()
System.name = "SelectObjectActionSystem"

---@param e Entity
function System:update(dt)
	local game = self.world.game
	local ctx = COMMON.CONTEXT:set_context_game_gui()
	local data = ctx.data
	local e = game.selected_object
	ctx.data:action_info_set_visible(false)
	if (e) then
		if (e.door and e.door_data.closed) then
			data:action_info_set_visible(true)
			if (e.door_data.key) then
				if (game.player.player_inventory.keys[e.door_data.key]) then
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