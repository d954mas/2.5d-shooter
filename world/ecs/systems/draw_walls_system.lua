local ECS = require 'libs.ecs'

local COMMON = require "libs.common"

local HASH_SPRITE_EAST = hash("sprite_east")
local HASH_SPRITE_WEST = hash("sprite_west")
local HASH_SPRITE_NORTH = hash("sprite_north")
local HASH_SPRITE_SOUTH = hash("sprite_south")
local HASH_SPRITE = hash("sprite")
local FACTORY_WALL_URL = msg.url("game:/factories#factory_wall")
local FACTORY_FLOOR_URL = msg.url("game:/factories#factory_floor")

--Draw wall and floors

local WallRenderObject = COMMON.class("WallRenderObject")
---@param url url
function WallRenderObject:initialize(url)
	self.url = assert(url)
	self.components = {
		sprite_east = msg.url(self.url.socket,self.url.path,HASH_SPRITE_EAST),
		sprite_west = msg.url(self.url.socket,self.url.path,HASH_SPRITE_WEST),
		sprite_north = msg.url(self.url.socket,self.url.path,HASH_SPRITE_NORTH),
		sprite_south = msg.url(self.url.socket,self.url.path,HASH_SPRITE_SOUTH)
	}
end

local FloorRenderObject = COMMON.class("FloorRenderObject")
---@param url url
function FloorRenderObject:initialize(url)
	self.url = assert(url)
	self.components = {
		sprite = msg.url(self.url.socket,self.url.path,HASH_SPRITE),
	}
end

---@class DrawWallsSystem:ECSSystem
local System = ECS.system()

function System:initialize()
	self.wall_objects = {} --map key is cell_id value is WallRenderObject
	self.floor_objects = {} --map key is cell_id valuee is FloorRenderObject
	self.ceil_objects = {} --map key is cell_id valuee is FloorRenderObject
end

System:initialize()



function System:sprite_set_image(url,id)
	local tile = self.world.world.level.data.id_to_tile[id]
	sprite.play_flipbook(url,hash(tile.image))
	go.set_scale(tile.scale,url)
end

function System:update(dt)
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.world.level:map_get_cell(x,y)
		if cell_data.wall.north ~= - 1 or cell_data.wall.south ~= - 1 or cell_data.wall.east ~= - 1 or cell_data.wall.west ~= - 1 then
			local wall_url = msg.url(factory.create(FACTORY_WALL_URL,vmath.vector3(x-0.5,0.5,-y+0.5),vmath.quat_rotation_z(0),nil))
			assert(not self.wall_objects[cell_data.id], "already created id:" .. cell_data.id)
			local wall_object = WallRenderObject(wall_url)
			self.wall_objects[cell_data.id] = wall_object
			self:sprite_set_image(wall_object.components.sprite_north,cell_data.wall.north)
			self:sprite_set_image(wall_object.components.sprite_south,cell_data.wall.south)
			self:sprite_set_image(wall_object.components.sprite_east,cell_data.wall.east)
			self:sprite_set_image(wall_object.components.sprite_west,cell_data.wall.west)
		end
		if cell_data.wall.floor ~= -1 then
			local floor_url = msg.url(factory.create(FACTORY_FLOOR_URL,vmath.vector3(x-0.5,0,-y+0.5),vmath.quat_rotation_z(0),nil,vmath.vector3(1/64)))
			assert(not self.floor_objects[cell_data.id], "already created id:" .. cell_data.id)
			local floor_object = FloorRenderObject(floor_url)
			self.floor_objects[cell_data.id] = floor_object
			self:sprite_set_image(floor_object.components.sprite,cell_data.wall.floor)
		end
		if cell_data.wall.ceil ~= -1 then
			local floor_url = msg.url(factory.create(FACTORY_FLOOR_URL,vmath.vector3(x-0.5,1,-y+0.5),vmath.quat_rotation_z(0),nil,vmath.vector3(1/64)))
			assert(not self.ceil_objects[cell_data.id], "already created id:" .. cell_data.id)
			local floor_object = FloorRenderObject(floor_url)
			self.ceil_objects[cell_data.id] = floor_object
			self:sprite_set_image(floor_object.components.sprite,cell_data.wall.ceil)
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.world.level:map_get_cell(x,y)
		if cell_data.wall.north ~= -1 then
			local object = self.wall_objects[cell_data.id]
			self.wall_objects[cell_data.id] = nil
			if object then
				go.delete(object.url)
			else
				--COMMON.w("can't unload not loaded id:" .. cell_data.id,TAG)
			end
		end
		if cell_data.wall.floor ~= -1 then
			local object = self.floor_objects[cell_data.id]
			self.floor_objects[cell_data.id] = nil
			if object then
				go.delete(object.url)
			else
				--COMMON.w("can't unload not loaded id:" .. cell_data.id,TAG)
			end
		end
		if cell_data.wall.ceil ~= -1 then
			local object = self.ceil_objects[cell_data.id]
			self.ceil_objects[cell_data.id] = nil
			if object then
				go.delete(object.url)
			else
				--COMMON.w("can't unload not loaded id:" .. cell_data.id,TAG)
			end
		end
	end
end




return System