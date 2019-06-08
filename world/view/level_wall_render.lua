local COMMON = require "libs.common"

local HASH_SPRITE_EAST = hash("sprite_east")
local HASH_SPRITE_WEST = hash("sprite_west")
local HASH_SPRITE_NORTH = hash("sprite_north")
local HASH_SPRITE_SOUTH = hash("sprite_south")
local FACTORY_WALL_URL = msg.url("game:/factories#factory_wall")

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

local M = COMMON.class("WallRender")

---@param level Level
function M:initialize(level)
	self.objects = {} --map key is cell_id value is WallRenderObject
	self.level = assert(level)
end

function M:update()
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.level:map_get_cell(x,y)
		if cell_data.wall.north ~= - 1 then
			local wall_object = msg.url(factory.create(FACTORY_WALL_URL,vmath.vector3(x-0.5,0.5,-y+0.5),nil,nil,vmath.vector3(1/64)))
			assert(not self.objects[cell_data.id],"already created id:" .. cell_data.id)
			self.objects[cell_data.id] = WallRenderObject(wall_object)
		end
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.level:map_get_cell(x,y)
		if cell_data.wall.north ~= -1 then
			local object = self.objects[cell_data.id]
			if object then
				self.objects[cell_data.id] = nil
				go.delete(object.url)
			else
				COMMON.w("can't unload not loaded id:" .. cell_data.id,TAG)
			end
		end

	end
end





return M