local ECS = require 'libs.ecs'

local HASH_SPRITE = hash("sprite")
local FACTORY_SPRITE_URL = msg.url("game:/factories#factory_sprite_object")
local FACTORY_EMPTY_URL = msg.url("game:/factories#factory_empty")
---@class DrawObjectsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("need_draw","pos")

---@param e Entity
function System:process(e, dt)
	local visible = native_raycasting.cells_get_by_coords(math.ceil(e.pos.x),math.ceil(e.pos.y)):get_visibility()
	if e.drawing and not visible then
		go.delete(e.sprite_url)
		e.drawing = false
		e.sprite_url = nil
		self.world:addEntity(e)
	end
	if not e.drawing and visible then
		assert(not e.sprite_url,"object already visible")
		--create simple go with one sprite
		if not e.go_url then
			e.go_url = msg.url(factory.create(FACTORY_EMPTY_URL,vmath.vector3(e.pos.x,0.5,-e.pos.z+0.5),vmath.quat_rotation_z(0)))
		end
		e.sprite_url =  msg.url(factory.create(FACTORY_SPRITE_URL,nil,vmath.quat_rotation_z(0)))
		e.sprite_url = msg.url(e.sprite_url.socket,e.sprite_url.path,HASH_SPRITE)
		go.set_parent(e.sprite_url,e.go_url)
		e.drawing = true
		e.tile = self.world.world.level.data.id_to_tile[e.tile_id]
		self:sprite_set_image(e)
		self.world:addEntity(e)
	end

end
---@param e Entity
function System:sprite_set_image(e)
	local tile = self.world.world.level.data.id_to_tile[e.tile_id]
	sprite.play_flipbook(e.sprite_url,hash(tile.image))
	go.set_scale(tile.scale,e.sprite_url)
	if tile.origin then
		go.set_position(vmath.vector3(e.tile.origin.x, e.tile.origin.y,0),e.sprite_url)
	end
end


return System