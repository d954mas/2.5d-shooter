local M = {}

M.GAME_WIDTH = 960
M.GAME_HEIGHT = 640

M.GUI_WIDTH = 960
M.GUI_HEIGHT = 640

M.sys_info = sys.get_sys_info()

M.ITEM_TYPES = {
	HEAD = "HEAD",
	WEAPON = "WEAPON",
	ARMOR = "ARMOR",
	GLOVES = "GLOVES",
	SHOES = "SHOES",
}

M.EQUIPMENT_SLOT = {
	HEAD = "HEAD",
	HAND_1 = "HAND_1",
	HAND_2 = "HAND_2",
	CHEST = "CHEST",
	GLOVES = "GLOVES",
	SHOES = "SHOES",
}

return M
