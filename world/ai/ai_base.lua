local COMMON = require "libs.common"
---@class AIStates
local AT_STATES = {
	CREATED = "CREATED",
	SPAWN = "SPAWN",
	IDLE = "IDLE"
}
local TAG = "AI"
---@class AI
local AI = COMMON.class("AIBase")

---@param e Entity
---@param game_controller GameController
function AI:initialize(e,game_controller)
	---@type ENTITIES
	self.ENTITIES = requiref("world.ecs.entities.entities")
	self.e = assert(e)
	self.game_controller = assert(game_controller)
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
	COMMON.i(string.format("state changed from:%s to:%s",tostring(old),self.state),TAG)
end

function AI:get_current_cell_position()
	return vmath.vector3(math.ceil(self.e.position.x),math.ceil(self.e.position.y),0)
end

function AI:animation_play(animation,comlete_function)
	sprite.play_flipbook(self.e.url_sprite,animation.animation,comlete_function)
	go.set_position(vmath.vector3(0,animation.dy,0),self.e.url_sprite)
end

--region Player
---@return Entity
function AI:player_get_entity()
	return self.game_controller.level.player
end

function AI:player_get_distance()
	return vmath.length(self.game_controller.level.player.position - self.e.position)
end

---@return NativeCellData[]
function AI:player_find_path()
	return self.game_controller:utils_find_path_to_player(self:get_current_cell_position())
end
--endregion


return AI