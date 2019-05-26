local COMMON = require "libs.common"
local M = {}

M.GAME = require "libs.atlases_data.game"
M.GUI = require "libs.atlases_data.gui"
M.ICONS = require "libs.atlases_data.icons"


return COMMON.read_only_recursive(M)