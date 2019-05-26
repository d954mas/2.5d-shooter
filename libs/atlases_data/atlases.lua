local COMMON = require "libs.common"
local M = {}

M.GAME = require "libs.atlases_data.game"
M.GUI = require "libs.atlases_data.gui"


return COMMON.read_only_recursive(M)