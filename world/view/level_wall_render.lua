local COMMON = require "libs.common"

local HASH_SPRITE_EAST = hash("sprite_east")
local HASH_SPRITE_WEST = hash("sprite_west")
local HASH_SPRITE_NORTH = hash("sprite_north")
local HASH_SPRITE_SOUTH = hash("sprite_south")
local HASH_SPRITE = hash("sprite")
local FACTORY_WALL_URL = msg.url("game:/factories#factory_wall")
local FACTORY_FLOOR_URL = msg.url("game:/factories#factory_floor")
local TILE_ID_TO_HASH = {}

local function INIT_ID_TO_HASHES()
	for id=1,20 do
		TILE_ID_TO_HASH[id] = hash("wall" .. id)
	end
end
INIT_ID_TO_HASHES()

local TAG = "WallRender"

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

local M = COMMON.class("WallRender")

---@param level Level
function M:initialize(level)
	self.wall_objects = {} --map key is cell_id value is WallRenderObject
	self.floor_objects = {} --map key is cell_id value is FloorRenderObject
	self.level = assert(level)
end

function M:update()
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.level:map_get_cell(x,y)
		if cell_data.wall.north ~= - 1 then
			local wall_url = msg.url(factory.create(FACTORY_WALL_URL,vmath.vector3(x-0.5,0.5,-y+0.5),nil,nil,vmath.vector3(1/64)))
			assert(not self.wall_objects[cell_data.id], "already created id:" .. cell_data.id)
			local wall_object = WallRenderObject(wall_url)
			self.wall_objects[cell_data.id] = wall_object
			for k,v in pairs(wall_object.components)do
				sprite.play_flipbook(v,TILE_ID_TO_HASH[cell_data.wall.north])
			end
		end
		if cell_data.wall.floor ~= -1 then
			local floor_url = msg.url(factory.create(FACTORY_FLOOR_URL,vmath.vector3(x-0.5,0,-y+0.5),nil,nil,vmath.vector3(1/64)))
			assert(not self.floor_objects[cell_data.id], "already created id:" .. cell_data.id)
			local floor_object = FloorRenderObject(floor_url)
			sprite.play_flipbook(floor_object.components.sprite,TILE_ID_TO_HASH[cell_data.wall.floor])
			self.floor_objects[cell_data.id] = floor_object
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.level:map_get_cell(x,y)
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
	end
end





return M