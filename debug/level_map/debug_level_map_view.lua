local COMMON = require "libs.common"
local WORLD = require "model.world"
local EVENTS = require "libs_project.events"

local WHITE_COLOR = string.char(0xff) .. string.char(0xff) .. string.char(0xff) .. string.char(0xff)
local WALL_COLOR = string.char(0xaa) .. string.char(0xaa) .. string.char(0xaa) .. string.char(0xff)
local NO_WALLS_COLOR = string.char(0x00) .. string.char(0x00) .. string.char(0x00) .. string.char(0xff)
local TRANSPARENT_COLOR = string.char(0x00) .. string.char(0x00) .. string.char(0x00) .. string.char(0x00)
local VISIBLE_COLOR = string.char(0xff) .. string.char(0x00) .. string.char(0x00) .. string.char(0x33)
local MIN_SIZE = 300

local View = COMMON.class("LevelMapDebugView")

function View:bind_vh()
	self.vh = {
		map_node = gui.get_node(self.root_name .. "/map"),
		map_visibility_node = gui.get_node(self.root_name .. "/visibility"),
		player_node = gui.get_node(self.root_name .. "/player")
	}
end

function View:textures_clear()
	if self.map_texture then
		gui.delete_texture("map")
		gui.delete_texture("map_visibility")
		self.map_texture = nil
		self.map_visibility_texture = nil
	end
end

function View:textures_update()
	if not (WORLD.battle_model and WORLD.battle_model.level and WORLD.battle_model.ecs.player) then return end
	local level = WORLD.battle_model.level
	local width, height = level:map_get_width(), level:map_get_height()
	if (not self.map_texture) then
		self.map_texture = gui.new_texture("map", width, height, "rgba", string.rep(WHITE_COLOR, width * height))
		self.map_visibility_texture = gui.new_texture("map_visibility", width, height, "rgba", string.rep(TRANSPARENT_COLOR, width * height))
		gui.set_texture(self.vh.map_node, "map")
		gui.set_texture(self.vh.map_visibility_node, "map_visibility")
		gui.set_size(self.vh.map_node, vmath.vector3(width, height, 1))
		gui.set_size(self.vh.map_visibility_node, vmath.vector3(width, height, 1))
	end

	local map_width = level:map_get_width()
	local map_height = level:map_get_height()
	--fast string concat https://stackoverflow.com/questions/19138974/does-lua-optimize-the-operator
	local buf_visible = {}
	local buf = {}
	print("*********************")
	for i = 0, level.cell_max_id do
		local cell = assert(level:map_get_wall_unsafe_by_id(i))
		local tile = cell.base ~= 0 and level:get_tile(cell.base)
		if cell.base == 0 then
			buf[i + 1] = WHITE_COLOR
		else
			buf[i + 1] = tile.properties.blocked and WALL_COLOR or WHITE_COLOR
		end
		buf_visible[i + 1] =  native_raycasting.cells_get_by_id(i):get_visibility() and VISIBLE_COLOR or TRANSPARENT_COLOR
	end

	gui.set_texture_data("map", map_width, map_height, "rgba", table.concat(buf), true)
	gui.set_texture_data("map_visibility", map_width, map_height, "rgba", table.concat(buf_visible), true)
	local scale = vmath.vector3(1)
	if map_width < map_height then
		scale.x = MIN_SIZE / map_width
	else
		scale.x = MIN_SIZE / map_height
	end
	scale.y = scale.x
	gui.set_scale(self.vh.map_node, scale)
	gui.set_position(self.vh.player_node, vmath.vector3(WORLD.battle_model.ecs.player.position.x, WORLD.battle_model.ecs.player.position.y - map_height, 0))
end

function View:initialize(root_name)
	self.root_name = assert(root_name)
	self:bind_vh()
	self.position_start = gui.get_position(self.vh.map_node)
	self.map_texture = nil
	self.scheduler = COMMON.RX.CooperativeScheduler.create()

	self.subscriptions = COMMON.RX.CompositeSubscription()
	self.subscriptions:add(COMMON.EVENT_BUS:subscribe(EVENTS.GAME_LEVEL_MAP_CHANGED):go_distinct(self.scheduler):subscribe(function(event) self:clear_textures() end))
end

function View:update(dt)
	self.scheduler:update(dt)
	self:textures_update()
end

function View:final()
	self.subscriptions:unsubscribe()
	self:textures_clear()
end

return View