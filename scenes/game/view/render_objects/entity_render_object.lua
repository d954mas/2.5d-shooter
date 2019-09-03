local COMMON = require "libs.common"
local FACTORY = require "scenes.game.factories"
local EMPTY_ROTATION = vmath.quat_rotation_x(0)
local RenderObject = require "scenes.game.view.render_objects.render_object"

--pickups boxes and etc
---@class EntityRenderObject:RenderObject
local Object = COMMON.class("GameObjectRenderObject",RenderObject)

function Object:initialize(config)
	RenderObject.initialize(self,config)
	---@type Entity
	self.e = assert(config.e)
	assert(not self.e.render_object)
	self.e.render_object = self
	self.position = vmath.vector3(self.e.position.x,self.e.position.z,-self.e.position.y)
end


function Object:create()
	if self.e.url_go then
		self.url_root = self.e.url_go
	else
		self.url_root = msg.url(factory.create(assert(self.url_factory_root),self.position,self.rotation,nil,self.scale))
		self.e.url_go = self.url_root
		self.game_controller.level.ecs_world:add_entity(self.e)
	end
	self.objects_container = {}
end

function Object:show()
	RenderObject.show(self)
end

function Object:hide()
	RenderObject.hide(self)
end

function Object:dispose()
	RenderObject.dispose(self)
end


return Object