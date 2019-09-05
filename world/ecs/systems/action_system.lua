local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"

---@class ActionSystem:ECSSystem
local System = ECS.system()
System.filter = ECS.requireAll("")

local TARGET_HASHES = {
	COMMON.HASHES.MSG_PHYSICS_GROUP_ACTION, COMMON.HASHES.MSG_PHYSICS_GROUP_OBSTACLE
}


---@param e Entity
function System:update(dt)
	local player_pos = self.world.game_controller.level.player.position
	local start_point = vmath.vector3(player_pos.x,0.5,-player_pos.y)
	local direction =  vmath.rotate(vmath.quat_rotation_y(self.world.game_controller.level.player.angle.x),vmath.vector3(0,0,-1))
	local end_point = start_point +  direction * 1
	local raycast = physics.raycast(start_point,end_point,TARGET_HASHES)
	if raycast then
		local e = ENTITIES.url_to_entity[raycast.id]
		if e then
			if e.door then self:gui_show("Door. Press <color=1,0,0,1><b>E</b></color> to open") return end
		end
	end

	--If not found action hide gui
	self:gui_hide()
end

function System:gui_hide()
	if self.gui_showing then
		self.gui_showing = false
		msg.post("/gui#game",COMMON.HASHES.MSG_GAME_GUI_HIDE_ACTION_LBL)
	end
end

function System:gui_show(text)
	if not self.gui_showing or self.text_action ~= text then
		self.gui_showing = true
		self.text_action = text
		msg.post("/gui#game",COMMON.HASHES.MSG_GAME_GUI_SHOW_ACTION_LBL,{text = self.text_action})
	end
end

System.gui_showing = false

return System