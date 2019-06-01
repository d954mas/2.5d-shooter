local require_f = require --ignore defold cyclic dependencies error
local COMMON = require "libs.common"
local ENTITIES = require "world.ecs.entities.entities"
local RENDER_CAM = require "rendercam.rendercam"

--Cell used in cpp and im lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0

local CAMERA_RAYS = 512
local CAMERA_FOV = 60 --can be changed
local CAMERA_MAX_DIST = 50
---@class Level
local Level = COMMON.class("Level")


function Level:initialize(data,world)
	---@type LevelData
	self.data = assert(data)
	self.world = require_f "world.world"
	self.prepared = false
end
-- prepared to play. Call it after create and before play
function Level:prepare()
	assert(not self.prepared,"lvl already prepared to play")
	self.prepared = true
	self.player = ENTITIES.create_player(vmath.vector3(self.data.spawn_point.x+0.5,self.data.spawn_point.y+0.5,0.5))
	native_raycasting.camera_set_rays(CAMERA_RAYS)
	native_raycasting.camera_set_max_distance(CAMERA_MAX_DIST)
	native_raycasting.map_set(self.data)
	self:update_fov()
end

function Level:update_fov()
	local aspect = RENDER_CAM.window.x/RENDER_CAM.window.y
	local v_fov = assert(RENDER_CAM.get_current_camera(),"no active camera").fov
	local h_fov = 2 * math.atan( math.tan( v_fov / 2 ) * aspect );
	native_raycasting.camera_set_fov(h_fov)
end

function Level:update(dt)
	self:update_fov()
end

--region MAP
function Level:map_get_width() return self.data.size.x end
function Level:map_get_height() return self.data.size.y end
---@return LevelDataCell
function Level:map_get_cell(x,y) return self.data.cells[y][x] end
function Level:map_cell_in(x,y)
	return x>=1 and x <= self:map_get_width() and y>=1 and y <=self:map_get_height()
end
--endregion




return Level