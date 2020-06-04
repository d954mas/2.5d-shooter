local ECS = require 'libs.ecs'
local CURSOR_HELPER = require "libs_project.cursor_helper"
local COMMON = require "libs.common"
local ENUMS = require "libs_project.enums"

---@class InputSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("input_info")
System.name = "InputSystem"

function System:input_mouse_move()
	local player = self.world.game.player
	player.angle.x = player.angle.x - CURSOR_HELPER.cursor_movement.x / 540
end

function System:input_weapon_select(weapon)
	self.world.game:player_weapon_change(weapon)
end

function System:input_interact()
	if (self.world.game.selected_object) then
		self.world.game:select_object_interact()
	end
end

function System:input_shoot(action_id, action)
	if (action.pressed) then
		self.world.game:player_weapon_get_active():input_pressed()
	elseif (action.released) then
		self.world.game:player_weapon_get_active():input_released()
	end

end

function System:init_input()
	self.movement = vmath.vector4(0) --up/down/left/right
	self.input_handler = COMMON.INPUT()
	self.input_handler:add_mouse(self.input_mouse_move)
	self.input_handler:add(COMMON.HASHES.INPUT.INTERACT, self.input_interact, true)
	self.input_handler:add(COMMON.HASHES.INPUT.TOUCH, self.input_shoot, true,false,true)
	self.input_handler:add(COMMON.HASHES.INPUT.WEAPON_1, function() self:input_weapon_select(ENUMS.WEAPON.PISTOL) end, true)
	self.input_handler:add(COMMON.HASHES.INPUT.WEAPON_2, function() self:input_weapon_select(ENUMS.WEAPON.SHOTGUN) end, true)
	self.input_handler:add(COMMON.HASHES.INPUT.WEAPON_3, function() self:input_weapon_select(ENUMS.WEAPON.RIFLE) end, true)
	self.input_handler:add(COMMON.HASHES.INPUT.WEAPON_4, function() self:input_weapon_select(ENUMS.WEAPON.MINIGUN) end, true)
	--self.input_handler:add(COMMON.HASHES.INPUT.TOUCH,self.make_shot)
end

function System:check_movement_input()
	self.movement.x = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT.UP] and 1 or 0
	self.movement.y = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT.DOWN] and 1 or 0
	self.movement.z = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT.RIGHT] and 1 or 0
	self.movement.w = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT.LEFT] and 1 or 0
end

function System:update_player_direction()
	self:check_movement_input()
	local player = self.world.game.player
	player.input_direction.x = self.movement.z - self.movement.w
	player.input_direction.y = self.movement.x - self.movement.y
	player.movement.direction.x = player.input_direction.x
	player.movement.direction.y = player.input_direction.y
	if player.movement.direction.x ~= 0 and player.movement.direction.y ~= 0 then
		player.movement.direction = vmath.normalize(player.movement.direction)
	end
end

function System:preProcess()
	--self.input_handler:on_input(self,e.input_info.action_id,e.input_info.action)
end

---@param e Entity
function System:process(e, dt)
	self.input_handler:on_input(self, e.input_info.action_id, e.input_info.action)
end
function System:postProcess()
	self:update_player_direction()
end

System:init_input()

return System