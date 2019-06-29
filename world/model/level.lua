local require_f = require --ignore defold cyclic dependencies error
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local ECS_WORLD = require "world.ecs.ecs"
--Cell used in cpp and in lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0

local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")


function Level:initialize(data)
	---@type LevelData
	self.data = assert(data)
	self.world = require_f "world.world"
	self.prepared = false
	self.ecs_world = ECS_WORLD()
	self.rotation_global = 0

	self.physics_subject = COMMON.RX.Subject.create()
	self.scheduler = COMMON.RX.CooperativeScheduler.create()
	self.subscriptions = COMMON.RX.SubscriptionsStorage()
	self.subscriptions:add(self.physics_subject:go(self.scheduler):subscribe(function(value)
		self.ecs_world.ecs:addEntity(ENTITIES.create_physics(value.message_id,value.message,value.source))
	end))
	ENTITIES.clear()
	ENTITIES.set_world(self.world)
	self:register_world_entities_callbacks()
end

function Level:register_world_entities_callbacks()
	self.ecs_world.ecs.on_entity_added = function(_,e)
		ENTITIES.on_entity_added(e)
	end
	self.ecs_world.ecs.on_entity_updated = function(_,e)
		ENTITIES.on_entity_updated(e)
	end
	self.ecs_world.ecs.on_entity_removed = function(_,e)
		ENTITIES.on_entity_removed(e)
	end
end

-- prepared to play. Call it after create and before play
function Level:prepare()
	assert(not self.prepared,"lvl already prepared to play")
	self.ecs_world:clear()
	self.prepared = true
	self.player = ENTITIES.create_player(vmath.vector3(self.data.spawn_point.x+0.5,self.data.spawn_point.y+0.5,0.5))
	self.ecs_world.ecs:addEntity(self.player)
	for _,object in ipairs(self.data.objects)do
		local e = ENTITIES.create_object_from_tiled(object)
		if e then self.ecs_world.ecs:addEntity(e) end
	end
	self:create_enemies()
	self:create_spawners()
end

function Level:create_enemies()
	for _, enemy in ipairs(self.data.enemies) do
		self.ecs_world.ecs:addEntity(ENTITIES.create(enemy.properties.name,nil,enemy))
	end
end

function Level:create_spawners()
	for _, spawner in ipairs(self.data.spawners) do
		local name = spawner.properties.name
		local f = ENTITIES["create_" .. name]
		if not f then
			COMMON.w("unknown spawner:" .. tostring(name),TAG)
		else
			self.ecs_world.ecs:addEntity(f(spawner))
		end
	end
end

function Level:update(dt)
	self.scheduler:update(dt)
	self.ecs_world:update(dt)
end

function Level:dispose()
	self.ecs_world:clear()
	self.physics_subject:onCompleted()
	self.subscriptions:unsubscribe()
end

--region MAP
function Level:map_get_width() return self.data.size.x end
function Level:map_get_height() return self.data.size.y end
---@return LevelDataCell
function Level:map_get_cell(x,y)
	assert(self:map_cell_in(x,y),"x:" .. x .. "y:" ..y)
	return self.data.cells[y][x]
end
function Level:map_cell_in(x,y)
	return x>=1 and x <= self:map_get_width() and y>=1 and y <=self:map_get_height()
end
--endregion




return Level