local COMMON = require "libs.common"
--very similar to AI now.
local TAG = "States"
---@class StatesBase
local States = COMMON.class("StatesBase")

---@param e Entity
---@param game_controller GameController
function States:initialize(states,e,game_controller)
	---@type ENTITIES
	self.ENTITIES = requiref("world.ecs.entities.entities")
	self.e = assert(e)
	self.game_controller = assert(game_controller)
	self.states = assert(states)
end

function States:update(dt)

end

function States:change_state(new_state)
	assert(self.states[new_state])
	if self.state ~= new_state then
		local old = self.state
		self.state = new_state
		self:state_changed(old)
	end
end

function States:state_changed(old)
	COMMON.i(string.format("state changed from:%s to:%s",tostring(old),self.state),TAG)
end

function States:get_current_cell_position()
	return vmath.vector3(math.ceil(self.e.position.x),math.ceil(self.e.position.y),0)
end

function States:animation_play(animation,comlete_function)
	sprite.play_flipbook(self.e.url_sprite,animation.animation,comlete_function)
	go.set_position(vmath.vector3(0,animation.dy,0),self.e.url_sprite)
end

--region Player
---@return Entity
function States:player_get_entity()
	return self.game_controller.level.player
end

function States:player_get_distance()
	return vmath.length(self.game_controller.level.player.position - self.e.position)
end

---@return NativeCellData[]
function States:player_find_path()
	return self.game_controller:utils_find_path_to_player(self:get_current_cell_position())
end
--endregion


return States