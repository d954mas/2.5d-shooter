local ECS = require 'libs.ecs'

local HASH_SPRITE = hash("sprite")
local EMPTY_ROTATION = vmath.quat_rotation_z(0) -- without rotation object have strange rotation
local FACTORY_SPRITE_URL = msg.url("game:/factories#factory_sprite_object")
local FACTORY_EMPTY_URL = msg.url("game:/factories#factory_empty")
---@class DrawObjectsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("culling","position")

---@param e Entity
function System:process(e, dt)
	local visible = native_raycasting.cells_get_by_coords(math.ceil(e.position.x),math.ceil(e.position.y)):get_visibility()
	if e.drawing and not visible then
		go.delete(e.url_sprite)
		e.drawing = false
		e.url_sprite = nil
		self.world:addEntity(e)
	end
	if not e.drawing and visible then
		assert(not e.url_sprite,"object already visible")
		--create simple go with one sprite
		if not e.url_go then
			e.url_go = msg.url(factory.create(FACTORY_EMPTY_URL,vmath.vector3(e.position.x,0,-e.position.z+0.5), EMPTY_ROTATION))
		end
		e.url_sprite =  msg.url(factory.create(FACTORY_SPRITE_URL,nil,EMPTY_ROTATION))
		e.url_sprite = msg.url(e.url_sprite.socket,e.url_sprite.path,HASH_SPRITE)
		go.set_parent(e.url_sprite,e.url_go)
		e.drawing = true
		e.tile = self.world.game_controller.level:get_tile(e.tile_id)
		self:sprite_set_image(e)
		self.world:addEntity(e)
	end
end
---@param e Entity
function System:sprite_set_image(e)
	local tile = e.tile
	sprite.play_flipbook(e.url_sprite,hash(tile.image))
	go.set_scale(tile.scale,e.url_sprite)
	local half_sprite = e.tile.height/2*tile.scale
	local sprite_offset = vmath.vector3(0,half_sprite,0)
	if tile.origin then
		sprite_offset.x = sprite_offset.x + tile.origin.x
		sprite_offset.y = sprite_offset.y + tile.origin.y
	end
	go.set_position(sprite_offset,e.url_sprite)
end


return System