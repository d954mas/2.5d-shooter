local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local CURSOR_HELPER = require "libs.cursor_helper"
local RENDER_CAM = require "rendercam.rendercam"
local WallRender = require "world.view.level_wall_render"

local CAMERA_RAYS = 512
local CAMERA_MAX_DIST = 50

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
	--self:create_walls()
	self.wall_render = WallRender(level)
	self:configure_camera()
	self:update_fov()
end

function LevelView:configure_camera()
	native_raycasting.camera_set_rays(CAMERA_RAYS)
	native_raycasting.camera_set_max_distance(CAMERA_MAX_DIST)
	native_raycasting.map_set(self.level.data)
end

function LevelView:update_fov()
	local aspect = RENDER_CAM.window.x/RENDER_CAM.window.y
	local v_fov = assert(RENDER_CAM.get_current_camera(),"no active camera").fov
	local h_fov = 2 * math.atan( math.tan( v_fov / 2 ) * aspect );
	native_raycasting.camera_set_fov(h_fov*1.2) --use bigger fov then camera
end


function LevelView:create_physics()
	self.physics_go = msg.url(factory.create(FACTORY_GO_EMPTY))
	local scale = math.max(self.level:map_get_width(),self.level:map_get_height())
	--mb i do not need floor.Place it a little lower then need, to avoid useless collision responses
	local floor = msg.url(factory.create(FACTORY_GO_BLOCK,vmath.vector3(scale/2,-scale/2+0.95,-scale/2),nil,nil,scale))
	go.set_parent(floor,self.physics_go)
	for y=1,self.level:map_get_height() do
		for x=1, self.level:map_get_width() do
			local cell = self.level:map_get_cell(x,y)
			if cell.blocked then
				local block = msg.url(factory.create(FACTORY_GO_BLOCK,vmath.vector3(x-0.5,0.5,-y+0.5)))
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
			if cell.wall.north ~= - 1 then
				local wall = msg.url(factory.create(FACTORY_GO_WALL,vmath.vector3(x-0.5,0.5,-y+0.5),nil,nil,vmath.vector3(1/64)))
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

function LevelView:update(dt)
	self.wall_render:update()
end

function LevelView:on_input(action_id,action)
	--mouse movement action_id is nil.Use hash instead of nil
	CURSOR_HELPER.on_input(action_id,action)
	self.level.ecs_world.ecs:addEntity(ENTITIES.create_input(action_id or COMMON.INPUT.HASH_NIL,action))
end

return LevelView

