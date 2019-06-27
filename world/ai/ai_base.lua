local COMMON = require "libs.common"
---@class AIStates
local AT_STATES = {
	CREATED = "CREATED",
	SPAWN = "SPAWN",
	IDLE = "IDLE"
}

---@class AI
local AI = COMMON.class("AIBase")

---@param e Entity
function AI:initialize(e,world)
	self.e = assert(e)
	self.world = assert(world)
	self.states = AT_STATES
	self:change_state(self.states.CREATED)
end

function AI:update(dt)

end

function AI:change_state(new_state)
	assert(self.states[new_state])
	if self.state ~= new_state then
		local old = self.state
		self.state = new_state
		self:state_changed(old)
	end
end

function AI:state_changed(old)
	COMMON.i(string.format("state changed from:%s to:%s",old,self.state))
end

---@return NativeCellData[]
function AI:find_path_to_player()
	local player = self.world.level.player
	local current_x, current_y = self:get_current_cell_position()
	return native_raycasting.map_find_path(current_x,current_y,
										   math.ceil(player.position.x),math.ceil(player.position.y))
end

function AI:get_current_cell_position()
	return math.ceil(self.e.position.x),math.ceil(self.e.position.y)
end

function AI:animation_play(animation,comlete_function)
	sprite.play_flipbook(self.e.url_sprite,animation.animation,comlete_function)
	go.set_position(vmath.vector3(0,animation.dy,0),self.e.url_sprite)
end

return AI