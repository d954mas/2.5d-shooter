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
		local pos = self.game_controller:utils_get_random_spawn_position_greater_than(4,10)
		if pos then
			self.game_controller.level.ecs_world.ecs:addEntity(self.ENTITIES.create(self.tiled_object.properties.spawn_enemy,pos))
			self.time = 0
		end
	end
end



return AI