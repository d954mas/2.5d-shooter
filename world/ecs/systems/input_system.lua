local ECS = require 'libs.ecs'
local CURSOR_HELPER = require "libs.cursor_helper"
local COMMON = require "libs.common"
local TAG = "InputSystem"

---@class InputSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("input_info")

function System:input_mouse_move()
	local player = self.world.game_controller.level.player
	player.angle.x = player.angle.x -CURSOR_HELPER.cursor_movement.x/540
end

function System:init_input()
	self.movement = vmath.vector4(0) --up/down/left/right
	self.input_handler = COMMON.INPUT()
	self.input_handler:add_mouse(self.input_mouse_move)
	self.input_handler:add(COMMON.HASHES.INPUT_TOUCH,self.make_shot)
end

function System:check_movement_input()
	self.movement.x = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT_UP] and 1 or 0
	self.movement.y = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT_DOWN]  and 1 or 0
	self.movement.z = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT_RIGHT]  and 1 or 0
	self.movement.w = COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT_LEFT]  and 1 or 0
end

function System:make_shot(action_id, action)
	local player = self.world.game_controller.level.player
	local weapon = player.weapons[player.weapon_current_idx]
	if action.pressed then weapon:on_pressed()
	elseif action.released then weapon:on_released()
	else weapon:pressed() end
end

function System:update_player_direction()
	self:check_movement_input()
	local player = self.world.game_controller.level.player
	player.input_direction.x = self.movement.z - self.movement.w
	player.input_direction.y = self.movement.x - self.movement.y
	player.movement_direction.x = player.input_direction.x
	player.movement_direction.y = player.input_direction.y
	if player.movement_direction.x ~= 0 and player.movement_direction.y ~= 0 then
		player.movement_direction = vmath.normalize(player.movement_direction)
	end
end

---@param e Entity
function System:process(e, dt)
	self.input_handler:on_input(self,e.input_info.action_id,e.input_info.action)
end
function System:postProcess(dt)
	self:update_player_direction()
end

System:init_input()

return System