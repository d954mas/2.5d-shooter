local ECS = require 'libs.ecs'

local HASH_SPRITE = hash("sprite")
local FACTORY_URL = msg.url("game:/factories#factory_sprite_object")
---@class DrawObjectsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("need_draw","pos")

---@param e Entity
function System:process(e, dt)
	local visible = self.visible_cell_map[math.ceil(e.pos.y)][math.ceil(e.pos.x)]
	if e.drawing and not visible then
		go.delete(e.go_url)
		e.go_url = nil
		e.drawing = false
		e.sprite_url = nil
		self.world:addEntity(e)
	end
	if not e.drawing and visible then
		assert(not e.go_url,"object already visible")
		--create simple go with one sprite
		local go_url = msg.url(factory.create(FACTORY_URL,vmath.vector3(e.pos.x,0.5,-e.pos.z+0.5)))
		local sprite_url = msg.url(go_url.socket,go_url.path,HASH_SPRITE)
		e.go_url = go_url
		e.sprite_url = sprite_url
		e.drawing = true
		self:sprite_set_image(e)
		self.world:addEntity(e)
	end
end
---@param e Entity
function System:sprite_set_image(e)
	local tile = self.world.world.level.data.id_to_tile[e.tile_id]
	sprite.play_flipbook(e.sprite_url,hash(tile.image))
	local scale_for_id = vmath.vector3(tile.width/64/64,tile.height/64/64,tile.width/64/64)
	go.set_scale(scale_for_id,e.go_url)
end

function System:preProcess()
	self.visible_cell = native_raycasting.cells_get_visible()
	self.visible_cell_map = {}
	for _,cell in ipairs(self.visible_cell) do
		if not self.visible_cell_map[cell:get_y()] then self.visible_cell_map[cell:get_y()] = {} end
			self.visible_cell_map[cell:get_y()][cell:get_x()] = true
	end
	setmetatable(self.visible_cell_map,{__index = function () return {} end}) --to work with nil row
end


return System