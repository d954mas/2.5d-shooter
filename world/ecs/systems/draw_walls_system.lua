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
	self.wall_transparent_objects = {} --map key is cell_id value is WallRenderObject Small wall for transparent tiles. Need to show correct color inside cell
	self.floor_objects = {} --map key is cell_id valuee is FloorRenderObject
	self.ceil_objects = {} --map key is cell_id valuee is FloorRenderObject
	self.wall_scale = 1/64 + 0.000001 --make wall bigger to get correct color and avoid z fighting for near walls
	self.wall_transparent_scale = 1/64 - 0.00001 --make wall smaller to get correct color(inner cell color) and avoid z fighting for main wall
	self.floor_scale = 1/64
	self.all_objects = {
		self.floor_objects,self.ceil_objects,self.wall_objects,self.wall_transparent_objects
	}
end

System:initialize()



function System:sprite_set_image(url,id)
	local tile = self.world.game_controller.level:get_tile(id)
	sprite.play_flipbook(url,tile.image)
	--go.set_scale(tile.scale,url) -- DO not works.It change scale of all object
end

function System:update(dt)
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		if cell_data.wall.north ~= - 1 or cell_data.wall.south ~= - 1 or cell_data.wall.east ~= - 1 or cell_data.wall.west ~= - 1 then
			local wall_url = msg.url(factory.create(FACTORY_WALL_URL,vmath.vector3(x-0.5,0.5,-y+0.5),vmath.quat_rotation_z(0),nil,self.wall_scale))
			assert(not self.wall_objects[cell_data.id], "already created id:" .. cell_data.id)
			local wall_object = WallRenderObject(wall_url)
			self.wall_objects[cell_data.id] = wall_object
			self:sprite_set_image(wall_object.components.sprite_north,cell_data.wall.north)
			self:sprite_set_image(wall_object.components.sprite_south,cell_data.wall.south)
			self:sprite_set_image(wall_object.components.sprite_east,cell_data.wall.east)
			self:sprite_set_image(wall_object.components.sprite_west,cell_data.wall.west)
			local tile = self.world.game_controller.level:get_tile(cell_data.wall.north)
			if tile.properties.transparent then --one or more edge transparent
				local wall_transparent_url = msg.url(factory.create(FACTORY_WALL_URL,vmath.vector3(x-0.5,0.5,-y+0.5),vmath.quat_rotation_z(0),nil,self.wall_transparent_scale))
				local wall_object_transparent = WallRenderObject(wall_transparent_url)
				self.wall_transparent_objects[cell_data.id] = wall_object_transparent
				self:sprite_set_image(wall_object_transparent.components.sprite_north,cell_data.wall.north)
				self:sprite_set_image(wall_object_transparent.components.sprite_south,cell_data.wall.south)
				self:sprite_set_image(wall_object_transparent.components.sprite_east,cell_data.wall.east)
				self:sprite_set_image(wall_object_transparent.components.sprite_west,cell_data.wall.west)
			end

		end
		if cell_data.wall.floor ~= -1 then
			local floor_url = msg.url(factory.create(FACTORY_FLOOR_URL,vmath.vector3(x-0.5,0,-y+0.5),vmath.quat_rotation_z(0),
													 nil,self.floor_scale))
			assert(not self.floor_objects[cell_data.id], "already created id:" .. cell_data.id)
			local floor_object = FloorRenderObject(floor_url)
			self.floor_objects[cell_data.id] = floor_object
			self:sprite_set_image(floor_object.components.sprite,cell_data.wall.floor)
		end
		if cell_data.wall.ceil ~= -1 then
			local floor_url = msg.url(factory.create(FACTORY_FLOOR_URL,vmath.vector3(x-0.5,1,-y+0.5),vmath.quat_rotation_z(0),
													 nil,self.floor_scale))
			assert(not self.ceil_objects[cell_data.id], "already created id:" .. cell_data.id)
			local floor_object = FloorRenderObject(floor_url)
			self.ceil_objects[cell_data.id] = floor_object
			self:sprite_set_image(floor_object.components.sprite,cell_data.wall.ceil)
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		for _, objects in ipairs(self.all_objects)do
			local object = objects[cell_data.id]
			if object then
				go.delete(object.url)
				objects[cell_data.id] = nil
			end
		end
	end
end




return System