local ECS = require 'libs.ecs'
local GameObjectRenderObject = require "scenes.game.view.render_objects.game_object_render_object"

---@class DrawObjectsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("culling","position")

---@param e Entity
function System:process(e, dt)
	local visible = native_raycasting.cells_get_by_coords(math.ceil(e.position.x),math.ceil(e.position.y)):get_visibility()

	if e.drawing and not visible then
		if e.render_object then e.render_object:hide() end
		e.drawing = false
	end

	if not e.drawing and visible then
		assert(not e.url_sprite,"object already visible")
		if not e.render_object then
			e.render_object = GameObjectRenderObject({position = vmath.vector3(),e = e})
			e.render_object:create()
		end
		e.render_object:show()
		e.drawing = true
		self.world:addEntity(e)
	end
end


return System