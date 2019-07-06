local COMMON = require "libs.common"
local AIBase = require "world.ai.ai_base"

---@class AISpawnerEnemy:AI
local AI = COMMON.class("AISpawnerEnemy",AIBase)


---@param e Entity
---@param game_controller GameController
function AI:initialize(e,game_controller,tiled_object)
	self.tiled_object = assert(tiled_object)
	assert(self.tiled_object.properties.delay, "no delay for spawner")
	AIBase.initialize(self,e,game_controller)
	self.time = 0
end

function AI:update(dt)
	AIBase.update(self,dt)
	self.time = self.time + dt
	if self.time > self.tiled_object.properties.delay and #self.ENTITIES.enemies<30 then
		local player = self:get_player_entity()
		local pos
		for i=1,10 do
			local spawn_pos = self:get_random_spawn_position()
			if vmath.length(player.position-spawn_pos) > 4 then
				pos = spawn_pos
				break
			end
		end
		if pos then
			self.game_controller.level.ecs_world.ecs:addEntity(self.ENTITIES.create(self.tiled_object.properties.spawn_enemy,pos))
			self.time = 0
		end
	end
end



return AI