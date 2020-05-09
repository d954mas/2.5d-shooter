local COMMON = require "libs.common"
local WORLD = require "model.world"
local COLORS = require "richtext.color"

local View = COMMON.class("AmmoPanelView")

local COLORS_GUI = {
	AMMO_BASE = COLORS.parse_hex("#7aa875"),
	AMMO_EMPTY = COLORS.parse_hex("#8d0000")
}

function View:initialize(root_name)
	checks("?", "string")
	self.root_name = root_name
	self:bind_vh()
	self:gui_init()
end

---@class AmmoPanelViewAmmoVH
---@field root
---@field lbl

---@return AmmoPanelViewAmmoVH
function View:bind_vh_ammo(name)
	return {
		root = gui.get_node(self.root_name .. "/" .. name),
		lbl = gui.get_node(self.root_name .. "/" .. name .. "/lbl_count")
	}

end

function View:bind_vh()
	self.vh = {
		root = gui.get_node(self.root_name),
		current = {
			root = gui.get_node(self.root_name .. "/current"),
			icon = gui.get_node(self.root_name .. "/current/icon"),
			lbl_count = gui.get_node(self.root_name .. "/current/lbl_count")
		},
		ammo = {
			pistol = self:bind_vh_ammo("pistol"),
			shotgun = self:bind_vh_ammo("shotgun"),
			rifle = self:bind_vh_ammo("rifle"),
			minigun = self:bind_vh_ammo("minigun"),
		}
	}

end
function View:gui_init()

end

function View:ammo_update(name)
	local player = WORLD.battle_model.ecs.player
	---@type AmmoPanelViewAmmoVH
	local vh = assert(self.vh.ammo[name], "unknown ammo:" .. name)
	local ammo = assert(player.player_inventory.ammo[name], "unknown ammo:" .. name)
	gui.set_text(vh.lbl, ammo)
	gui.set_color(vh.lbl, ammo > 0 and COLORS_GUI.AMMO_BASE or COLORS_GUI.AMMO_EMPTY)
end

function View:ammo_update_all()
	gui.set_text(self.vh.current.lbl_count, WORLD.battle_model.ecs.player.player_inventory.ammo.pistol)
	self:ammo_update("pistol")
	self:ammo_update("shotgun")
	self:ammo_update("rifle")
	self:ammo_update("minigun")
end

function View:update(dt)
	self:ammo_update_all()
end

return View