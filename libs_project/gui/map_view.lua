local COMMON = require "libs.common"
local WORLD = require "model.world"
local COLORS = require "richtext.color"

local TAG = "MapView"

local View = COMMON.class("MapView")

---@class MapViewCellView
local MapViewCellView = COMMON.CLASS("MapViewCellView")

---@param vh MapViewNodeEmptyVH|MapViewNodeWallVH
---@param wall LevelDataWallBlock|nil
function MapViewCellView:initialize(vh, wall)
	self.vh = assert(vh)
	self.wall = wall
end

function MapViewCellView:dispose()
	gui.delete_node(self.vh.root)
	self.vh = nil
	self.wall = nil
end

function MapViewCellView:set_position(x, y)
	gui.set_position(self.vh.root, vmath.vector3(x, y, 0))
end

---@class MapViewConfig
local ConfigDef = {
	w = "number",
	h = "number"
}

---@class MapViewNodeWallVH
---@field root

---@class MapViewNodeEmptyVH
---@field root

---@param config MapViewConfig
function View:initialize(root_name, config)
	checks("?", "string", ConfigDef)
	assert(config.w > 0, "w should be bigger 0")
	assert(config.h > 0, "h should be bigger 0")
	self.root_name = root_name
	self.config = config
	---@type MapViewCellView[]
	self.views = {}
	self:bind_vh()
	self:gui_init()
end

function View:bind_vh()
	self.vh = {
		root = gui.get_node(self.root_name .. "/root"),
		node_empty = gui.get_node(self.root_name .. "/node_empty"),
		node_wall = gui.get_node(self.root_name .. "/node_wall"),
		clipping = gui.get_node(self.root_name .. "/clipping"),
		clipping_root = gui.get_node(self.root_name .. "/clipping/root")
	}
end

function View:gui_init()
	local size = gui.get_size(self.vh.clipping)
	local scale_w, scale_h = size.x / (self.config.w * 32), size.y / (self.config.h * 32)
	if (scale_w ~= scale_h) then
		COMMON.w("map view scale not same", TAG)
	end
	local scale = math.max(scale_h, scale_w)
	gui.set_scale(self.vh.clipping_root, vmath.vector3(scale))
	gui.set_enabled(self.vh.node_empty, false)
	gui.set_enabled(self.vh.node_wall, false)
end

function View:update(dt)

end

---@return MapViewNodeWallVH
function View:node_create_wall()
	local nodes = gui.clone_tree(self.vh.node_wall)
	local vh = {
		root = assert(nodes[COMMON.HASHES.hash(self.root_name .. "/node_wall")])
	}
	gui.set_enabled(vh.root, true)
	return vh
end

---@return MapViewNodeEmptyVH
function View:node_create_empty()
	local nodes = gui.clone_tree(self.vh.node_empty)
	local vh = {
		root = assert(nodes[COMMON.HASHES.hash(self.root_name .. "/node_empty")])
	}
	gui.set_enabled(vh.root, true)
	return vh
end

function View:set_position_center(pos_x, pos_y)
	for _, cell in pairs(self.views) do
		cell.__need_check = true
	end

	local level = WORLD.battle_model.level
	self.position = vmath.vector3(pos_x, pos_y, 0)
	local v_half, h_half = self.config.w / 2, self.config.h / 2

	for y = math.floor(pos_y - v_half), math.ceil(pos_y + v_half) do
		for x = math.floor(pos_x - h_half), math.ceil(pos_x + h_half) do
			local id = level:coords_to_id(x, y)
			---@type MapViewCellView
			local view = self.views[id]
			if not view then
				local vh
				---@type LevelDataWallBlock
				local wall_cell
				if level:coords_valid(x, y) then
					wall_cell = level:map_get_wall_by_id(id)
					vh = wall_cell.native_cell:get_blocked() and self:node_create_wall() or self:node_create_empty()
				else
					vh = self:node_create_empty()
				end
				view = MapViewCellView(vh, wall_cell)
			else
			end
			view:set_position((0.5 + x - pos_x) * 32, (0.5 + y - pos_y) * 32)
			self.views[id] = view
			view.__need_check = nil
		end
	end

	for id, cell in pairs(self.views) do
		if (cell.__need_check) then
			cell:dispose()
			self.views[id] = nil
		end
	end


end

return View