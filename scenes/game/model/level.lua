local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local ECS_WORLD = require "world.ecs.ecs"
local FACTORY = require "scenes.game.factories"

local TILESET


--Cell used in cpp and in lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0

local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")

---@param data LevelData
function Level:initialize(data)
	if TILESET == nil then
		--load tileset once
		TILESET = json.decode(assert(sys.load_resource("/assets/levels/result/tileset.json"),"no tileset"))
		for k,v in pairs(TILESET)do
			if v.image then v.image = hash(v.image) end
		end
	end
	self.data = assert(data)
	self.ecs_world = ECS_WORLD()
	self.scheduler = COMMON.RX.CooperativeScheduler.create()

	self.rotation_global = 0
	self.physics_subject = COMMON.RX.Subject.create()

	self.subscriptions = COMMON.RX.SubscriptionsStorage()
	self.subscriptions:add(self.physics_subject:go(self.scheduler):subscribe(function(value)
		self.ecs_world:add_entity(ENTITIES.create_physics(value.message_id,value.message,value.source))
	end))

	self:register_world_entities_callbacks()
end

function Level:register_world_entities_callbacks()
	self.ecs_world.ecs.on_entity_added = function(_,e) ENTITIES.on_entity_added(e) end
	self.ecs_world.ecs.on_entity_updated = function(_,e) ENTITIES.on_entity_updated(e) end
	self.ecs_world.ecs.on_entity_removed = function(_,e) ENTITIES.on_entity_removed(e) end
end

--region prepare
-- prepared to play. Call it after create and before play
function Level:prepare()
	assert(not self.player,"lvl already prepared to play")
	self.player = ENTITIES.create_player(vmath.vector3(self.data.spawn_point.x,self.data.spawn_point.y,0.5))
	self.player.angle.x = math.rad(self.data.spawn_point.angle)
	self.ecs_world:add_entity(self.player)
	self:light_map_build()
	--if call after doors it will create not needed colliders
	self:create_physics()
	self:create_doors()
	self:create_draw_objects()
	self:create_enemies()
	self:create_spawners()
	self:create_pickups()
end

function Level:create_doors()
	for _,object in ipairs(self.data.doors)do
		local cell = self:map_get_cell(object.cell_x,object.cell_y)
		assert(not cell.blocked,"can't create door on blocked cell")
		cell.blocked = true
		cell.transparent = true
		native_raycasting.map_cell_set_blocked(cell.position.x,cell.position.y,true)
		native_raycasting.map_cell_set_transparent(cell.position.x,cell.position.y,true)
		local door_e = ENTITIES.create_door(object)
		self.ecs_world:add_entity(door_e)
	end
end

function Level:light_map_build()
	COMMON.RENDER:update_light_map(self.data.light_map,self.data.size.x,self.data.size.y)
end

function Level:create_draw_objects()
	for _,object in ipairs(self.data.objects)do
		local e = ENTITIES.create_draw_object_from_tiled(object)
		if e then self.ecs_world:add_entity(e) end
	end
end

function Level:create_enemies()
	for _, enemy in ipairs(self.data.enemies) do
		self.ecs_world:add_entity(ENTITIES.create_from_object(enemy.properties.name,enemy))
	end
end

function Level:create_spawners()
	for _, spawner in ipairs(self.data.spawners) do
		local name = spawner.properties.name
		local f = ENTITIES["create_" .. name]
		if not f then
			COMMON.w("unknown spawner:" .. tostring(name),TAG)
		else
			self.ecs_world:add_entity((f(spawner)))
		end
	end
end

function Level:create_pickups()
	for _, pickup in ipairs(self.data.pickups) do
		self.ecs_world:add_entity(ENTITIES.create_pickup_from_object(pickup))
	end
end

function Level:create_physics()
	assert(not self.physics_go,"physics go already created")
	self.physics_go = msg.url(factory.create(FACTORY.FACTORY.empty))
	local scale = math.max(self:map_get_width(),self:map_get_height())
	--mb i do not need floor.Place it a little lower then need, to avoid useless collision responses
	local floor = msg.url(factory.create(FACTORY.FACTORY.block,vmath.vector3(scale/2,-scale/2+0.95,-scale/2),nil,nil,scale))
	go.set_parent(floor,self.physics_go)
	for y=1,self:map_get_height() do
		for x=1, self:map_get_width() do
			local cell = self:map_get_cell(x,y)
			if cell.blocked then
				local block = msg.url(factory.create(FACTORY.FACTORY.block,vmath.vector3(x-0.5,0.5,-y+0.5)))
				go.set_parent(block,self.physics_go)
			end
		end
	end
end

--endregion
function Level:update(dt)
	self.scheduler:update(dt)
	self.ecs_world:update(dt)
end

function Level:dispose()
	self.ecs_world:clear()
	self.physics_subject:onCompleted()
	self.subscriptions:unsubscribe()
	go.delete(self.physics_go,true)
	self.physics_go = nil
end

--region MAP
function Level:map_get_width() return self.data.size.x end
function Level:map_get_height() return self.data.size.y end
---@return LevelDataCell
function Level:map_get_cell(x,y)
	assert(self:map_cell_in(x,y),"x:" .. x .. "y:" ..y)
	return self.data.cells[y][x]
end

function Level:map_get_cell_unsafe(x,y)
	return self.data.cells[y][x]
end
function Level:map_cell_in(x,y)
	return x>=1 and x <= self:map_get_width() and y>=1 and y <=self:map_get_height()
end

---@return LevelDataTile
function Level:get_tile(id)
	return assert(TILESET.by_id[id],"no tile with id:" .. id)
end

function Level:get_tile_for_tileset(tileset_name,id)
	assert(tileset_name)
	assert(id)
	local tileset = assert(TILESET.tilesets[tileset_name], "no tileset with name:" .. tileset_name)
	local tile_id = tileset.first_gid + id
	assert(tile_id <= tileset.end_gid, "no tile:" .. tile_id .. " in tileset:" .. tileset_name .. " end:" .. tileset.end_gid)
	return self:get_tile(tile_id), tile_id
end
--endregion




return Level