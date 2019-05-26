local COMMON = require "libs.common"
local LUME = require "libs.lume"
local GUI_UTILS = require "libs.gui_utils"

---@class RecyclerView
local RecyclerView = COMMON.class("GuiRecyclerView")

local function create_margin_area(root_node,margin)
	local box = gui.new_box_node(vmath.vector3(0), vmath.vector3(0))
	gui.set_parent(box,root_node)
	gui.set_pivot(box, gui.PIVOT_NW)
	gui.set_clipping_mode(box, gui.CLIPPING_MODE_STENCIL)
	gui.set_texture(box,"gui")
	gui.play_flipbook(box,"empty")
	return box
end

local function create_scroll_area(root_node, r)
	local size = gui.get_size(r)
	local box = gui.new_box_node(vmath.vector3(size.x/2,0,0), size)
	gui.set_parent(box,root_node)
	gui.set_pivot(box, gui.PIVOT_N)
	gui.set_texture(box,"gui")
	gui.play_flipbook(box,"empty")
	return box
end


function RecyclerView:initialize(root)
	self.margin = {top = 0, bottom=0}
	self.items = {}
	self.root = assert(root)
	self.margin_area = create_margin_area(root, self.margin)
	self:_update_margin()
	self.scroll_area = create_scroll_area(self.margin_area, self.root)

	self.scroll_area_pos = gui.get_position(self.scroll_area)
	self.scroll_area_size = gui.get_size(self.scroll_area)
end

function RecyclerView:set_margin(top, bottom)
	if top then self.margin.top = top end
	if bottom then self.margin.bottom = bottom end
	self:_update_margin()
end

function RecyclerView:_update_margin()
	local size = gui.get_size(self.root)
	size.y = size.y - self.margin.top - self.margin.bottom
	gui.set_size(self.margin_area,size)
	gui.set_position(self.margin_area,vmath.vector3(0,size.y+self.margin.bottom,0))
end

---@param adapter RecyclerViewAdapter
function RecyclerView:set_adapter(adapter)
	assert(adapter)
	assert(not self.adapter, "adapter can be set only once")
	self.adapter = adapter
	self:_fill_cells()
end

function RecyclerView:_fill_cells()
	assert(#self.items==0)
	assert(self.adapter)

	local vh, nodes = self.adapter:create_view_holder()
	assert(nodes)
	local root_node = nodes[self.adapter.root_node_name]
	gui.set_parent(root_node, self.scroll_area)
	gui.set_pivot(root_node, gui.PIVOT_N)
	gui.set_position(root_node,vmath.vector3(0,0,0))
	table.insert(self.items, {nodes = nodes, root_node = root_node, idx = 1, vh = vh})
	self.node_size = GUI_UTILS.get_scaled_size(root_node)

	local need_nodes = math.ceil(self.scroll_area_size.y/self.node_size.y) + 1
	for i=2, need_nodes do
		local vh, nodes = self.adapter:create_view_holder()
		assert(nodes)
		local root_node = nodes[self.adapter.root_node_name]
		gui.set_parent(root_node, self.scroll_area)
		gui.set_pivot(root_node, gui.PIVOT_N)
		print("pos:" .. -self.node_size.y *(i-1))
		gui.set_position(root_node,vmath.vector3(0,-self.node_size.y *(i-1),0))
		table.insert(self.items, {nodes = nodes, root_node = root_node, idx = i, vh = vh})
	end
	self.scroll_borders = {min = - self.scroll_area_size.y * 0.2, max = self.node_size.y * need_nodes - self.scroll_area_size.y
		+ self.scroll_area_size.y * 0.2
	}
end

function RecyclerView:update(dt)

end


function RecyclerView:on_input(action_id, action)
	if action_id == COMMON.HASHES.INPUT_TOUCH then
		if action.released then
			self.touched = false
			self.prev_action = nil
			return
		elseif action.pressed then
			if gui.pick_node(self.root, action.x, action.y) then
				self.touched = true
				self.prev_action = action
			end
		end

		if self.touched then
			local dy = action.y - self.prev_action.y
			self.prev_action = action
			self.scroll_area_pos.y = LUME.clamp(self.scroll_area_pos.y + dy, self.scroll_borders.min, self.scroll_borders.max)
			gui.set_position(self.scroll_area, self.scroll_area_pos)
		end
	end

end

function RecyclerView:scroll_to(index, speed)

end

function RecyclerView:set_scroll_position(y)

end

function RecyclerView:set_scroll_position_to_item(index)

end

function RecyclerView:items_changed()

end

function RecyclerView:item_changed(index)

end

return RecyclerView
