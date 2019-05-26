local COMMON = require "libs.common"
local GOOEY = require "gooey.gooey"
local ATLASES = require "libs.atlases_data.atlases"
--region headers
---@class GooeyListItem
---@field root node
---@field size vector3
---@field index number
---@field nodes node[] gui.clone_tree nodes
---@field data table


---@class GooeyList
---@field stencil node
---@field id string root id
---@field scroll_pos vector3
---@field scroll vector3  Scrolled amount from the top (only scroll.y is used). The scroll amount is in the range 0.0 (top) to 1.0 (bottom).
---@field data_size number
---@field refresh_fn function
---@field first_item_pos number
---@field stencil_size vector3
---@field min_y number
---@field dynamic boolean
---@field set_visible function
---@field item_size vector3
---@field scrolling boolean
---@field max_y number
---@field consumed boolean true if the input was consumed
---@field items GooeyListItem[]
---@field data table[]
---@field enabled boolean true if the node is enabled
---@field scroll_to function
---@field refresh function
---@field over boolean true if user action is over any list item
---@field over_item number Index of the list item the user action is over
---@field over_item_now number  Index of the list item the user action moved inside this call
---@field out_item_now number  Index of the list item the user action moved outside this call
---@field selected_item number  Index of the selected list item
---@field pressed_item number Index of the pressed list item (ie mouse/touch down but not yet released)
---@field pressed_item_now number Index of the list item the user action pressed this call
---@field released_item_now number Index of the list item the user action released this call
--endregion
local M = GOOEY.create_theme()
--region list items
--region BaseListItem
---@class BaseListItem
local BaseListItem = COMMON.class("BaseListItem")
function BaseListItem:initialize(item_id)
	self.item_id = assert(item_id)
	self:bind_hashes()
end

function BaseListItem:bind_hashes()
	self.hashes = {}
end

function BaseListItem:get_hash(string)
	return hash(self.item_id .. "/" .. string)
end

---@param list GooeyList
---@param item GooeyListItem
function BaseListItem:update_visual(list,item)

end
--endregion

--region DefaultListItem
---@class DefaultListItem:BaseListItem
local DefaultListItem = COMMON.class("DefaultListItem",BaseListItem)

function DefaultListItem:bind_hashes()
	self.hashes = {
		bg = self:get_hash("bg"),
		lbl = self:get_hash("lbl"),
	}
	self.images = {
		common_tab = hash("common_tab"),
		common_tab_selected = hash("common_tab_selected"),
	}
end

---@param list GooeyList
---@param item GooeyListItem
function DefaultListItem:update_visual(list,item)
	if item.index == list.selected_item then
		gui.play_flipbook(item.nodes[self.hashes.bg], self.images.common_tab_selected)
	else
		gui.play_flipbook(item.nodes[self.hashes.bg], self.images.common_tab)
	end
	gui.set_text(item.nodes[self.hashes.lbl],item.data and item.data.title or "")
end
--endregion

--region DefaultListItem
---@class LabelListItem:BaseListItem
local LabelListItem = COMMON.class("LabelListItem",BaseListItem)

function LabelListItem:bind_hashes()
	self.hashes = {
		lbl = self:get_hash("lbl"),
	}
end

---@param list GooeyList
---@param item GooeyListItem
function LabelListItem:update_visual(list,item)
	gui.set_text(item.nodes[self.hashes.lbl],item.data and item.data.text or "")
end
--endregion


--region CellsRowListItem
---@class CellsRowListItem:BaseListItem
local CellsRowListItem = COMMON.class("CellsRowListItem",BaseListItem)

function CellsRowListItem:bind_hashes()
	self.hashes = {
	--	bg = self:get_hash("bg"),
		--lbl = self:get_hash("lbl"),
	}
	self.images = {
		--common_tab = hash("common_tab"),
		--common_tab_selected = hash("common_tab_selected"),
	}
end

function CellsRowListItem:bind_cell_hashes(idx)
	assert(idx)
	self.hashes["cell_" .. idx] = {
		root = self:get_hash("cell_" .. idx .. "/root"),
		cell = self:get_hash("cell_" .. idx .. "/cell"),
		icon = self:get_hash("cell_" .. idx .. "/icon"),
		cell_hover = self:get_hash("cell_" .. idx .. "/cell_hover")
	}
end

function CellsRowListItem:get_cell_hashes(idx)
	if not self.hashes["cell_" .. idx] then
		self:bind_cell_hashes(idx)
	end
	return self.hashes["cell_" .. idx]
end

---@param list GooeyList
---@param item GooeyListItem
function CellsRowListItem:update_visual(list,item)
	if not item.data then
		return
	end
	assert(item.data)
	for i,cell in ipairs(item.data) do
		self:update_cell(item,self:get_cell_hashes(i),cell)
	end
end
---@param item GooeyListItem
function CellsRowListItem:update_cell(item,hashes,cell)
	local hover = item.nodes[hashes.cell_hover]
	gui.set_enabled(hover,cell.selected)
	---@type BasePrinciple
	local data = cell.data
	gui.play_flipbook(item.nodes[hashes.icon],data.image)
end
---@param list GooeyList
---@param item GooeyListItem
function CellsRowListItem:on_click(list,item)
	for i,cell in ipairs(item.data) do
		if gui.pick_node(item.nodes[self:get_cell_hashes(i).root],list.action_pos.x,list.action_pos.y) then return cell, i end
	end
end

--endregion

--region dynamic_list
local DynamicList = COMMON.class("GuiDynamicList")

---@class GooeyDynamicList
---@param item BaseListItem
function DynamicList:initialize(root_id,item_id,data,item)
	self.root_id = assert(root_id)
	self.stencil_id = root_id .. "/stencil"
	self.item_id = assert(item_id)
	self.data = assert(data)
	assert(item:isInstanceOf(BaseListItem))
	self.item = item
	self.refresh_f = function (...) self:update_list(...) end
	self.select_f = function (...) self:item_selected(...) end
	--emulate click to create list
	self.list = self:on_input(nil,{x=0,y=0})
	self.on_click_f = nil
end

function DynamicList:data_changed()
	self:on_input(nil,{x=0,y=0})
end

---@param list GooeyList
function DynamicList:item_selected(list)
	if self.on_click_f then
		self:on_click_f(list.data[list.selected_item],list)
	end
end

---@param list GooeyList
function DynamicList:update_list(list)
	for _,item in ipairs(list.items) do
		self:update_item(list, item)
	end
end
---@param list GooeyList
---@param item GooeyListItem
function DynamicList:update_item(list,item)
	self.item:update_visual(list,item)
end

---@param y number in range [0;1]
function DynamicList:scroll_to(y)
	self.list.scroll_to(self.list,y)
end

---@return GooeyList
function DynamicList:on_input(action_id,action)
	return GOOEY.dynamic_list(self.root_id,self.stencil_id , self.item_id, self.data, action_id, action, self.select_f,self.refresh_f,true )
end

function DynamicList:set_selected(idx)
	assert(idx)
	assert(self.data[idx])
	self.list.selected_item = idx
	self:item_selected(self.list)
	self:update_list(self.list)
end
--endregion

local function refresh_button(button)
	if button.pressed then
		gui.play_flipbook(button.node, ATLASES.GUI.common_button_clicked.texture)
	else
		gui.play_flipbook(button.node, ATLASES.GUI.common_button.texture)
	end
end

function M.button(root, action_id, action, fn)
	return GOOEY.button(root, action_id, action, fn,refresh_button)
end

function M.button2(node_id, action_id, action, fn)
	return gooey.button(node_id .. "/bg", action_id, action, fn, refresh_button)
end


function M.dynamic_list(root_id, data, action_id, action, fn)

	--return GOOEY.dynamic_list(root_id, , root_id.."/item", data, action_id, action, fn, update_dynamic_list)
end

function M.tab_list()

end



local BUTTON_PRESSED = hash("button_pressed")
local BUTTON_NORMAL = hash("button_normal")

local CHEKCKBOX_PRESSED = hash("checkbox_pressed")
local CHEKCKBOX_CHECKED_PRESSED = hash("checkbox_checked_pressed")
local CHEKCKBOX_CHECKED_NORMAL = hash("checkbox_checked_normal")
local CHEKCKBOX_NORMAL = hash("checkbox_normal")

local RADIO_PRESSED = hash("radio_pressed")
local RADIO_CHECKED_PRESSED = hash("radio_checked_pressed")
local RADIO_CHECKED_NORMAL = hash("radio_checked_normal")
local RADIO_NORMAL = hash("radio_normal")

local LISTITEM_SELECTED = hash("button_pressed")
local LISTITEM_PRESSED = hash("button_pressed")
local LISTITEM_OVER = hash("button_normal")
local LISTITEM_NORMAL = hash("button_normal")




local function refresh_button(button)
	if button.pressed then
	gui.play_flipbook(button.node, BUTTON_PRESSED)
else
	gui.play_flipbook(button.node, BUTTON_NORMAL)
end
end
function M.button2(node_id, action_id, action, fn)
	return gooey.button(node_id .. "/bg", action_id, action, fn, refresh_button)
end


local function refresh_checkbox(checkbox)
	if checkbox.pressed and not checkbox.checked then
		gui.play_flipbook(checkbox.node, CHEKCKBOX_PRESSED)
	elseif checkbox.pressed and checkbox.checked then
		gui.play_flipbook(checkbox.node, CHEKCKBOX_CHECKED_PRESSED)
	elseif checkbox.checked then
		gui.play_flipbook(checkbox.node, CHEKCKBOX_CHECKED_NORMAL)
	else
		gui.play_flipbook(checkbox.node, CHEKCKBOX_NORMAL)
	end
end
function M.checkbox(node_id, action_id, action, fn)
	return gooey.checkbox(node_id .. "/box", action_id, action, fn, refresh_checkbox)
end


local function refresh_radiobutton(radio)
	if radio.pressed and not radio.selected then
		gui.play_flipbook(radio.node, RADIO_PRESSED)
	elseif radio.pressed and radio.selected then
		gui.play_flipbook(radio.node, RADIO_CHECKED_PRESSED)
	elseif radio.selected then
		gui.play_flipbook(radio.node, RADIO_CHECKED_NORMAL)
	else
		gui.play_flipbook(radio.node, RADIO_NORMAL)
	end
end
function M.radiogroup(group_id, action_id, action, fn)
	return gooey.radiogroup(group_id, action_id, action, fn)
end
function M.radio(node_id, group_id, action_id, action, fn)
	return gooey.radio(node_id .. "/button", group_id, action_id, action, fn, refresh_radiobutton)
end


local function refresh_input(input, config, node_id)
	if input.empty and not input.selected then
		gui.set_text(input.node, config and config.empty_text or "")
	end

	local cursor = gui.get_node(node_id .. "/cursor")
	if input.selected then
		gui.set_enabled(cursor, true)
		gui.set_position(cursor, vmath.vector3(14 + input.total_width, 0, 0))
		gui.cancel_animation(cursor, gui.PROP_COLOR)
		gui.set_color(cursor, vmath.vector4(1))
		gui.animate(cursor, gui.PROP_COLOR, vmath.vector4(1,1,1,0), gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
	else
		gui.set_enabled(cursor, false)
		gui.cancel_animation(cursor, gui.PROP_COLOR)
	end
end
function M.input(node_id, keyboard_type, action_id, action, config)
	return gooey.input(node_id .. "/text", keyboard_type, action_id, action, config, function(input)
		refresh_input(input, config, node_id)
	end)
end


local function update_listitem(list, item)
	local pos = gui.get_position(item.root)
	if item.index == list.selected_item then
		pos.x = 4
		gui.play_flipbook(item.root, LISTITEM_PRESSED)
	elseif item.index == list.pressed_item then
		pos.x = 1
		gui.play_flipbook(item.root, LISTITEM_SELECTED)
	elseif item.index == list.over_item_now then
		pos.x = 1
		gui.play_flipbook(item.root, LISTITEM_OVER)
	elseif item.index == list.out_item_now then
		pos.x = 0
		gui.play_flipbook(item.root, LISTITEM_NORMAL)
	elseif item.index ~= list.over_item then
		pos.x = 0
		gui.play_flipbook(item.root, LISTITEM_NORMAL)
	end
	gui.set_position(item.root, pos)
end


local function update_static_list(list)
	for _,item in ipairs(list.items) do
		update_listitem(list, item)
	end
end
function M.static_list(list_id, item_ids, action_id, action, fn)
	return gooey.static_list(root_id, list_id .. "/stencil", item_ids, action_id, action, fn, update_static_list)
end


local function update_dynamic_list(list)
	for _,item in ipairs(list.items) do
		update_listitem(list, item)
		gui.set_text(item.nodes[hash(list.id .. "/listitem_text")], tostring(item.data or "-"))
	end
end
function M.dynamic_list(list_id, data, action_id, action, fn)
	return gooey.dynamic_list(list_id, list_id .. "/stencil", list_id .. "/listitem_bg", data, action_id, action, fn, update_dynamic_list)
end


M.DynamicList = DynamicList
M.BaseListItem = BaseListItem
M.CellsRowListItem = CellsRowListItem
M.DefaultListItem = DefaultListItem
M.LabelListItem = LabelListItem

return M