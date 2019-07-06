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
	COMMON.i(string.format("state changed from:%s to:%s",tostring(old),self.state))
end

---@return NativeCellData[]
function AI:find_path_to_player()
	local player = self.game_controller.level.player
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

--TODO CAN LOOP INFINITY
--TODO FIX PERFORMANCE
function AI:get_random_spawn_position()
	local w,h = self.game_controller.level:map_get_width(), self.game_controller.level:map_get_height()
	while true do
		local x,y = math.random(1,w), math.random(1,h)
		local map_cell = self.game_controller.level:map_get_cell(x,y)
		if not map_cell.blocked  and map_cell.wall.floor ~= -1 then
			return vmath.vector3(x,y,0)
		end
	end
end

---@return Entity
function AI:get_player_entity()
	return self.game_controller.level.player
end

function AI:get_distance_to_player()
	return vmath.length(self.game_controller.level.player.position - self.e.position)
end


return AI