local COMMON = require "libs.common"
local FACTORY = require "scenes.game.factories"
local RenderObject = require "scenes.game.view.render_objects.render_object"

local WALL_SIDE_CONFIGS = {
	north = {
		rotation = vmath.quat_rotation_y(math.rad(180)),
		position = vmath.vector3(0,0.5,-0.5)
	},
	south = {
		rotation = vmath.quat_rotation_y(math.rad(0)),
		position = vmath.vector3(0,0.5,0.5)
	},
	east = {
		rotation = vmath.quat_rotation_y(math.rad(90)),
		position = vmath.vector3(0.5,0.5,0)
	},
	west = {
		rotation = vmath.quat_rotation_y(math.rad(90)),
		position = vmath.vector3(-0.5,0.5,0)
	},
	floor = {
		rotation = vmath.quat_rotation_x(math.rad(90)),
		position = vmath.vector3(0,0,0),
		no_transparent = true-- do not copy in transparent inner go
	},
	ceil = {
		rotation = vmath.quat_rotation_x(math.rad(90)),
		position = vmath.vector3(0,1,0),
		no_transparent = true
	},
	thin = {
		rotation_f = function(tile)
			return vmath.quat_rotation_y(math.rad(tile.properties.angle or 0))
		end,
		position = vmath.vector3(0,0.5,0),
		no_transparent = true
	}
}

---@class WallRenderObject:RenderObject
local Object = COMMON.class("RenderObject",RenderObject)

---@param position vector3
function Object:initialize(config)
	RenderObject.initialize(self,config)
	--transparent is small object inside regular wall
	self.transparent = config.transparent
	self.transparent_object = nil
	self.scale = self.transparent and 0.9990 or 1.0001
	---@type LevelDataCell
	self.cell_data = assert(config.cell_data)
	self.position = vmath.vector3(self.cell_data.position.x-0.5,0,-self.cell_data.position.y+0.5)
end

function Object:create()
	RenderObject.create(self)
	if not self.transparent then
		for k,v in pairs(self.cell_data.wall)do
			if v~=-1 and WALL_SIDE_CONFIGS[k] then --v == -1 empty wall side
				local wall_config = WALL_SIDE_CONFIGS[k]
				local tile = self.game_controller.level:get_tile(v)
				if (not wall_config.no_transparent and tile.properties.transparent) then
					local config = COMMON.LUME.clone_deep(self.config)
					config.transparent = true
					self.transparent_object = Object(config)
					break
				end
			end
		end
	end
	if self.transparent_object then self.transparent_object:create() end
end

function Object:show()
	RenderObject.show(self)
	for k,v in pairs(self.cell_data.wall)do
		if v~=-1 and WALL_SIDE_CONFIGS[k] then --v == -1 empty wall side
			local config = WALL_SIDE_CONFIGS[k]
			local tile = self.game_controller.level:get_tile(v)
			if  not(self.transparent and config.no_transparent) then
				local rotation = config.rotation_f and config.rotation_f(tile) or config.rotation
				local sprite_go = msg.url(factory.create(FACTORY.FACTORY.sprite_wall,config.position,rotation,nil,tile.scale))
				sprite.play_flipbook(sprite_go,tile.image)
				self:root_add_object(sprite_go)
			end
		end
	end
	if self.transparent_object then self.transparent_object:show() end
end

function Object:hide()
	RenderObject.hide(self)
	if self.transparent_object then self.transparent_object:hide() end
end
function Object:dispose()
	RenderObject.dispose(self)
	if self.transparent_object then self.transparent_object:dispose() end
end


return Object