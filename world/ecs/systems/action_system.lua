local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local TAG = "ActionSystem"

---@class ActionSystem:ECSSystem
local System = ECS.system()
System.filter = ECS.requireAll("")

local TARGET_HASHES = {
	COMMON.HASHES.MSG_PHYSICS_GROUP_ACTION, COMMON.HASHES.MSG_PHYSICS_GROUP_OBSTACLE
}

local TEXT_DOOR_OPEN = "Press <color=1,0,0,1><b>E</b></color> to open"
local TEXT_DOOR_NEED_KEY = "Need <size=0.6><img=objects:%s/></size>"

function System:onAddToWorld(world)
	---@type LevelDataTile[]
	self.keys = {
		blue = self.world.game_controller.level:get_tile_for_tileset("pickups",3),
		green = self.world.game_controller.level:get_tile_for_tileset("pickups",4),
		white = self.world.game_controller.level:get_tile_for_tileset("pickups",5),
		yellow = self.world.game_controller.level:get_tile_for_tileset("pickups",6),
	}
end

---@param e Entity
function System:open_door(e)
	if e.door_opened then
		COMMON.w("door already opened",TAG)
		return
	end
	if e.tile.properties.key then
		assert(self.world.game_controller.level.player.inventory.keys[e.tile.properties.key],"no key:" .. tostring(e.tile.properties.key))
	end
	e.door_opened = true
	e.go_do_not_update_position = true
	local current_pos = go.get_position(e.url_go)
	go.animate(e.url_go,"position.y",go.PLAYBACK_ONCE_FORWARD,current_pos.y + 1,go.EASING_INOUTSINE,1,0)
	timer.delay(0.5,false,function()
		msg.post(e.url_collision_action,COMMON.HASHES.MSG_DISABLE)
		msg.post(e.url_collision_obstacle,COMMON.HASHES.MSG_DISABLE)
		local cell = self.world.game_controller.level:map_get_cell(math.ceil(e.position.x),math.ceil(e.position.y))
		cell.blocked = false
		cell.transparent = true
		native_raycasting.map_cell_set_blocked(cell.position.x,cell.position.y,false)
		native_raycasting.map_cell_set_transparent(cell.position.x,cell.position.y,true)
	end)



end

---@param e Entity
function System:update(dt)
	local player_pos = self.world.game_controller.level.player.position
	local start_point = vmath.vector3(player_pos.x,0.5,-player_pos.y)
	local direction =  vmath.rotate(vmath.quat_rotation_y(self.world.game_controller.level.player.angle.x),vmath.vector3(0,0,-1))
	local end_point = start_point +  direction * 1
	local raycast = physics.raycast(start_point,end_point,TARGET_HASHES)
	local key_action_pressed = self.world.game_controller.level.player.key_action_pressed
	self.world.game_controller.level.player.key_action_pressed = nil
	self:gui_hide()
	if raycast then
		local e = ENTITIES.url_to_entity[raycast.id]
		local can_opened = false
		if e then
			if e.door and not e.door_opened then
				if e.tile.properties.key then
					local key_tile = assert(self.keys[e.tile.properties.key])
					if self.world.game_controller.level.player.inventory.keys[e.tile.properties.key] then
						can_opened = true
					else
						self:gui_show(string.format(TEXT_DOOR_NEED_KEY,key_tile.image))
					end
				else
					can_opened = true
				end
			end
			if can_opened then
				self:gui_show(TEXT_DOOR_OPEN)
				if key_action_pressed then
					self:open_door(e)
				end
			end
		end
	end

	--If not found action hide gui

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