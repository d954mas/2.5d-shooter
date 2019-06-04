local ECS = require 'libs.ecs'
local CURSOR_HELPER = require "libs.cursor_helper"
local COMMON = require "libs.common"

---@class InputSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("input","input_action_id","input_action")

function System:input_mouse_move(action)
	local player = self.world.world.level.player
	player.angle.x = player.angle.x -CURSOR_HELPER.cursor_movement.x/540
end

local function get_input_movement_fun(name)
	return function(self,action_id,action)
		if action.pressed then self.movement[name] = 1
		elseif action.released then self.movement[name] = 0 end
	end
end


function System:init_input()
	self.movement = vmath.vector4(0) --up/down/left/right
	self.input_handler = COMMON.INPUT()
	self.input_handler:add_mouse(self.input_mouse_move)
	self.input_handler:add(COMMON.HASHES.INPUT_UP,get_input_movement_fun("x"))
	self.input_handler:add(COMMON.HASHES.INPUT_DOWN,get_input_movement_fun("y"))
	self.input_handler:add(COMMON.HASHES.INPUT_LEFT,get_input_movement_fun("z"))
	self.input_handler:add(COMMON.HASHES.INPUT_RIGHT,get_input_movement_fun("w"))
end

function System:update_player_velocity()
	self.world.world.level.player.direction.x = self.movement.z - self.movement.w
	self.world.world.level.player.direction.y = self.movement.x - self.movement.y
end




---@param e Entity
function System:process(e, dt)
	self.input_handler:on_input(self,e.input_action_id,e.input_action)
	self.world:removeEntity(e)
end
function System:postProcess(dt)
	self:update_player_velocity()
end

System:init_input()

return System