local COMMON = require "libs.common"
local FACTORY = require "scenes.game.factories"
local TAG = "RenderObject"
---@class RenderObject
local Object = COMMON.class("RenderObject")

---@param position vector3
function Object:initialize(config)
	assert(config)
	self.config = config
	self.position = assert(config.position)
	self.scale = config.scale or 1
	self.rotation = config.rotation or vmath.quat_rotation_z(0)
	self.url_factory_root = config.url_factory_root or FACTORY.FACTORY.empty
	self.showing = false
	---@type GameController
	self.game_controller = requiref "scenes.game.model.game_controller"
	self.objects_container = {}
end

function Object:create()
	self.url_root = msg.url(factory.create(self.url_factory_root,self.position,self.rotation,nil,self.scale))
	self.objects_container = {}
end

function Object:show()
	assert(self.url_root,"not created")
	assert(not self.showing,"already show")
	self.showing = true
end

--keep only root go. All other should be deleted
function Object:hide()
	assert(self.showing,"already hide")
	self.showing = false
	for _,object in ipairs(self.objects_container)do
		go.delete(object,true)
	end
	self.objects_container = {}
end

function Object:dispose()
	if not self.url_root then
		COMMON.w("can't dispose not created object",TAG)
		return
	end
	self.showing = false
	go.delete(self.url_root,true)
	self.url_root = nil
	self.objects_container = {}
end

function Object:root_add_object(url_object)
	go.set_parent(assert(url_object),self.url_root)
	table.insert(self.objects_container,url_object)
end

return Object