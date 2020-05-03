local COMMON = require "libs.common"
local RichText = require "richtext.richtext"

local base ={
    fonts = {
        Base = {
            regular = hash("roboto_regular"),
            italic = hash("roboto_italic"),
            bold = hash("roboto_bold"),
            bold_italic = hash("roboto_bold_italic"),
        },
    },
    align = RichText.ALIGN_CENTER,
    width = 400,
    color = vmath.vector4(1, 1, 1, 1.0),
    outline = vmath.vector4(0, 0, 0, 0.0),
    shadow = vmath.vector4(0, 0, 0, 0.0),
    position = vmath.vector3(0,0,0)
}

local base_left = COMMON.LUME.clone_deep(base)
base_left.align = RichText.ALIGN_LEFT



COMMON.read_only(base)
COMMON.read_only(base_left)

local M = {}
M.BASE_CENTER = base
M.BASE_LEFT = base_left

function M.base_center(vars)
    return M.make_copy(M.BASE_CENTER,vars)
end

function M.base_left(vars)
    return M.make_copy(M.BASE_LEFT,vars)
end

function M.make_copy(root,vars)
    local c = COMMON.LUME.clone_deep(root)
    COMMON.LUME.merge_table(c,vars)
    return c
end


return M