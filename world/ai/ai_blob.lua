local COMMON = require "libs.common"
local AIBase = require "world.ai.ai_base"

---@class AIBlob:AI
local AI = COMMON.class("AIBlob",AIBase)

---@param e Entity
---@param world World
function AI:initialize(e,world)
	AIBase.initialize(self,e,world)
	self:change_state(self.states.IDLE)
end

function AI:update(dt)
	AIBase.update(self,dt)
	local next_cell = self:find_path_to_player()[2]
	if next_cell then
		local current_x, current_y = self:get_current_cell_position()
		local dx,dy = next_cell:get_x() - current_x,next_cell:get_y() - current_y
		local cell_dx,cell_dy = 1-(current_x  - self.e.position.x), 1-(current_y - self.e.position.y)
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
end


return AI