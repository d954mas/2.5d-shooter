local COMMON = require "libs.common"
local LUME = require "libs.lume"
local Base = require "gui.recycler_list_adapter"

---@class InventoryViewAdapter:RecyclerViewAdapter
local Adapter = Base:subclass("InventoryViewAdapter")



--OVERRIDE ME
function Adapter:create_view_holder()
	local cell = gui.clone_tree(self.base_cell)
	gui.set_enabled(cell[self.root_node_name], true)
	return {}, cell
end
--OVERRIDE ME
function Adapter:bind_view_holder(view_holder, position)

end




return Adapter
