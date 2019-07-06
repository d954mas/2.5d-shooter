local ECS = require 'libs.ecs'

local COMMON = require "libs.common"

local HASH_SPRITE_EAST = hash("sprite_east")
local HASH_SPRITE_WEST = hash("sprite_west")
local HASH_SPRITE_NORTH = hash("sprite_north")
local HASH_SPRITE_SOUTH = hash("sprite_south")
local HASH_SPRITE = hash("sprite")
local FACTORY_EMPTY_URL = msg.url("game:/factories#factory_empty")
local FACTORY_SPRITE_WALL_URL = msg.url("game:/factories#factory_sprite_wall")

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
	self.all_objects = {
		self.wall_objects,self.wall_transparent_objects
	}
	self.wall_side_configs = {
		north = {
			rotation = vmath.quat_rotation_y(math.rad(180)),
			position = vmath.vector3(0,0.5,-0.5)
		},
		south = {
			rotation = vmath.quat_rotation_y(math.rad(0)),
			position = vmath.vector3(0,0.5,0.5)
		},
		east = {
			rotation = vmath.quat_rotation_y(math.rad(90)),
			position = vmath.vector3(0.5,0.5,0)
		},
		west = {
			rotation = vmath.quat_rotation_y(math.rad(90)),
			position = vmath.vector3(-0.5,0.5,0)
		},
		floor = {
			rotation = vmath.quat_rotation_x(math.rad(90)),
			position = vmath.vector3(0,0,0),
			no_transparent = true
		},
		ceil = {
			rotation = vmath.quat_rotation_x(math.rad(90)),
			position = vmath.vector3(0,1,0),
			no_transparent = true
		}
	}
end

System:initialize()



function System:sprite_set_image(url,id)
	local tile = self.world.game_controller.level:get_tile(id)
	sprite.play_flipbook(url,tile.image)
	--go.set_scale(tile.scale,url) -- DO not works.It change scale of all object
end

function System:create_wall_object(cell_data,x,y,transparent)
	local root_go,transparent_go
	local have_transparent = false
	local scale = transparent and 0.9990 or 1.0001
	if transparent then
		assert(not self.wall_transparent_objects[cell_data.id], "already created id:" .. cell_data.id)
	else
		assert(not self.wall_objects[cell_data.id], "already created id:" .. cell_data.id)
	end
	for k,v in pairs(cell_data.wall)do
		if v~=-1 and self.wall_side_configs[k] then
			local config = self.wall_side_configs[k]
			local tile = self.world.game_controller.level:get_tile(v)
			have_transparent = have_transparent or tile.properties.transparent
			if  not(transparent and config.no_transparent) then
				root_go = root_go or msg.url(factory.create(FACTORY_EMPTY_URL,vmath.vector3(x-0.5,0,-y+0.5),vmath.quat_rotation_z(0),nil,scale))
				local sprite_go = msg.url(factory.create(FACTORY_SPRITE_WALL_URL,config.position,config.rotation,nil,tile.scale))
				sprite.play_flipbook(sprite_go,tile.image)
				go.set_parent(sprite_go,root_go)
			end
		end
	end
	--need same go but smaller for inner cell lights
	if not transparent and have_transparent then
		transparent_go = self:create_wall_object(cell_data,x,y,true)
	end
	return root_go,transparent_go
end

function System:update(dt)
	local need_load = native_raycasting.cells_get_need_load()
	for _,cell in ipairs(need_load)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		self.wall_objects[cell_data.id],self.wall_transparent_objects[cell_data.id] = self:create_wall_object(cell_data,x,y)
	end
	local need_unload = native_raycasting.cells_get_need_unload()
	for _,cell in ipairs(need_unload)do
		local x,y =cell:get_x(),cell:get_y()
		local cell_data = self.world.game_controller.level:map_get_cell(x,y)
		for _, objects in ipairs(self.all_objects)do
			local object = objects[cell_data.id]
			if object then
				go.delete(object,true)
				objects[cell_data.id] = nil
			end
		end
	end
end




return System