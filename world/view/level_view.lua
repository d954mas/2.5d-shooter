local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local FACTORY_GO_EMPTY = msg.url("game:/factories#factory_empty")
local FACTORY_GO_BLOCK = msg.url("game:/factories#factory_block")
local FACTORY_GO_WALL = msg.url("game:/factories#factory_wall")
local LevelView = COMMON.class("LevelView")

function LevelView:initialize()
	self.physics_go = nil
end

---@param level Level
function LevelView:build_level(level)
	self:dispose()
	self.level = level
	self:create_physics()
	self:create_walls()
end

function LevelView:create_physics()
	self.physics_go = msg.url(factory.create(FACTORY_GO_EMPTY))
	local floor = msg.url(factory.create(FACTORY_GO_BLOCK,vmath.vector3(self.level:map_get_width()/2,-1,self.level:map_get_height()/2),nil,nil
			,vmath.vector3(self.level:map_get_width(),1,self.level:map_get_height())))
	go.set_parent(floor,self.physics_go)
	for y=1,self.level:map_get_height() do
		for x=1, self.level:map_get_width() do
			local cell = self.level:map_get_cell(x,y)
			if cell.blocked then
				local block = msg.url(factory.create(FACTORY_GO_BLOCK,vmath.vector3(x-0.5,0.5,y-0.5)))
				go.set_parent(block,self.physics_go)
			end
		end
	end
end

function LevelView:create_walls()
	self.walls_go = msg.url(factory.create(FACTORY_GO_EMPTY))
	for y=1,self.level:map_get_height() do
		for x=1, self.level:map_get_width() do
			local cell = self.level:map_get_cell(x,y)
			if cell.wall ~= - 1 then
				local wall = msg.url(factory.create(FACTORY_GO_WALL,vmath.vector3(x-0.5,0.5,y-0.5),nil,nil,vmath.vector3(1/64)))
				go.set_parent(wall,self.walls_go)
			end
		end
	end
end

function LevelView:dispose()
	if self.level then
		go.delete(self.physics_go,true)
		self.physics_go = nil
		self.level = nil
	end
end

function LevelView:update()
end

function LevelView:on_input(action_id,action)
	--mouse movement action_id is nil.Use hash instead of nil
	self.level.ecs_world.ecs:addEntity(ENTITIES.create_input(action_id or COMMON.INPUT.HASH_NIL,action))
end

return LevelView

