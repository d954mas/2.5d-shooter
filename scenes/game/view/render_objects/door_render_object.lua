local COMMON = require "libs.common"
local FACTORY = require "scenes.game.factories"
local EMPTY_ROTATION = vmath.quat_rotation_x(0)
local EntityRenderObject = require "scenes.game.view.render_objects.entity_render_object"
local WallRenderObject = require "scenes.game.view.render_objects.wall_render_object"

--pickups boxes and etc
---@class DoorRenderObject:EntityRenderObject
local Object = COMMON.class("DoorRenderObject",EntityRenderObject)

function Object:initialize(config)
	EntityRenderObject.initialize(self,config)
	---@type LevelDataCell
	local cell_data = {wall = {
		 north = self.e.tile.id, south = self.e.tile.id, east = self.e.tile.id, west = self.e.tile.id,
		 floor = -1, ceil = -1,
	},position = vmath.vector3(0.5,0.5,0)}

	self.door_wall_object = WallRenderObject({position = vmath.vector3(0),cell_data = cell_data,transparent = true})
end

function Object:create()
	EntityRenderObject.create(self)
	self.door_wall_object:create()
	go.set_parent(self.door_wall_object.url_root,self.url_root)
end


function Object:show()
	EntityRenderObject.show(self)
	self.door_wall_object:show()
end

function Object:hide()
	EntityRenderObject.hide(self)
	self.door_wall_object:hide()
end

function Object:dispose()
	self.door_wall_object:dispose()
	EntityRenderObject.dispose(self)
end



return Object