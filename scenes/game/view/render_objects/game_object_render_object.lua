local COMMON = require "libs.common"
local FACTORY = require "scenes.game.factories"
local EMPTY_ROTATION = vmath.quat_rotation_x(0)
local RenderObject = require "scenes.game.view.render_objects.render_object"

--pickups boxes and etc
---@class GameObjectRenderObject:RenderObject
local Object = COMMON.class("GameObjectRenderObject",RenderObject)

function Object:initialize(config)
	RenderObject.initialize(self,config)
	---@type Entity
	self.e = assert(config.e)
	assert(not self.e.render_object)
	self.e.render_object = self
	self.position = vmath.vector3(self.e.position.x,0,-self.e.position.y)
end


function Object:create()
	if self.e.url_go then
		self.url_root = self.e.url_go
	else
		self.url_root = msg.url(factory.create(self.url_factory_root,self.position,self.rotation,nil,self.scale))
		self.e.url_go = self.url_root
		self.game_controller.level.ecs_world:add_entity(self.e)
	end
	self.objects_container = {}
end

function Object:show()
	RenderObject.show(self)
	assert(not self.e.url_sprite,"already have sprite")
	--create sprites and add them to root go
	self.e.url_sprite =  msg.url(factory.create(FACTORY.FACTORY.sprite,nil,EMPTY_ROTATION))
	self.e.url_sprite = msg.url(self.e.url_sprite.socket,self.e.url_sprite.path,FACTORY.COMPONENT_HASHES.sprite)
	self.e.dynamic_color_cell = nil -- reset dynamic color.If not reset, objects will not update color on next appear
	self:root_add_object(self.e.url_sprite)
	self.e.drawing = true
	self:sprite_set_image()
	self.game_controller.level.ecs_world:add_entity(self.e)
end

function Object:hide()
	RenderObject.hide(self)
	self.e.dynamic_color_cell = nil -- reset dynamic color.If not reset, objects will not update color on next appear
	self.e.drawing = nil
	self.e.url_sprite = nil
	self.game_controller.level.ecs_world:add_entity(self.e)
end

---@param e Entity
function Object:sprite_set_image()
	local tile = self.e.tile
	sprite.play_flipbook(self.e.url_sprite,tile.image_hash)
	go.set_scale(tile.scale,self.e.url_sprite)
	local half_sprite = self.e.tile.height/2*tile.scale
	local sprite_offset = vmath.vector3(0,half_sprite,0)
	if tile.origin then
		sprite_offset.x = sprite_offset.x + tile.origin.x
		sprite_offset.y = sprite_offset.y + tile.origin.y
	end
	go.set_position(sprite_offset,self.e.url_sprite)
end


function Object:dispose()
	RenderObject.dispose(self)
end


return Object