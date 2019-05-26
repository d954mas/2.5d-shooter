local COMMON = require "libs.common"
local LUME = require "libs.lume"

---@class RecyclerViewAdapter
local Adapter = COMMON.class("GuiRecyclerViewAdapter")


function Adapter:initialize(data, cell_name)
	assert(data)
	self.data = data
	assert(cell_name)
	self.root_node_name = hash(cell_name)
	local root_node = gui.get_node(self.root_node_name)
	self.base_cell = root_node
	gui.set_enabled(self.base_cell, false)
	self.data = data
end

function Adapter:items_changed()
	self.view:items_changed()
end

function Adapter:item_changed(index)
	self.view:item_changed(index)
end

---@param view RecyclerView
function Adapter:add_to_view(view)
	self.view = view
end


--OVERRIDE ME
---@return viewholder
---@return node
function Adapter:create_view_holder()

end
--OVERRIDE ME
function Adapter:bind_view_holder(view_holder, position)

end




return Adapter
