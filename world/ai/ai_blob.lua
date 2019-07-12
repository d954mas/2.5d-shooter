local COMMON = require "libs.common"
local AIBase = require "world.ai.ai_base"

---@class AIBlob:AI
local AI = COMMON.class("AIBlob",AIBase)

local ANIMATIONS = {
	SPAWN = {animation = hash("blob_spawn"), dy = 64},
	IDLE =  {animation =hash("blob_idle"), dy = 32}
}

---@param e Entity
---@param game_controller GameController
function AI:initialize(e,game_controller)
	AIBase.initialize(self,e,game_controller)
	self:change_state(self.states.SPAWN)
end

function AI:update(dt)
	AIBase.update(self,dt)
	if self.state == self.states.IDLE then
		local next_cell = self:player_find_path()[2]
		if next_cell then
			local current_pos = self:get_current_cell_position()
			local dx,dy = next_cell:get_x() - current_pos.x,next_cell:get_y() - current_pos.y
			local cell_dx,cell_dy = 1-(current_pos.x  - self.e.position.x), 1-(current_pos.y - self.e.position.y)
			if dy ~= 0 and dx==0 and (cell_dx <0.4 or cell_dx > 0.6) then
				dy = 0
				dx =  0.5 - cell_dx
			elseif dx ~= 0 and dy==0 and (cell_dy <0.4 or cell_dy > 0.6) then
				dx = 0
				dy =  0.5 - cell_dy
			end
			self.e.velocity.x = dx
			self.e.velocity.y = dy
		else
			self.e.velocity.x = 0
			self.e.velocity.y = 0
		end
		local dist_to_player = self:player_get_distance()
		if dist_to_player < 1.1 then
			self.e.weapons[self.e.weapon_current_idx]:shoot()
		end
	end
end



function AI:state_changed(old)
	if self.state == self.states.IDLE then
		self:animation_play(ANIMATIONS.IDLE)
	elseif self.state == self.states.SPAWN then
		self:animation_play(ANIMATIONS.SPAWN,function ()
			self:change_state(self.states.IDLE)
		end)
	end
end


return AI