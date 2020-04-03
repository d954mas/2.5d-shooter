native_raycasting = {}

function native_raycasting.camera_update(x, y, angle) end
function native_raycasting.camera_set_fov(fov) end
function native_raycasting.camera_set_rays(rays) end
function native_raycasting.camera_set_max_distance(max_distance) end

---@param level_data LevelData
function native_raycasting.map_set(level_data) end
function native_raycasting.map_find_path(x, y, x2, y2) end
function native_raycasting.map_cell_set_blocked(x, y, blocked) end
function native_raycasting.map_cell_set_transparent(x, y, transparent) end

function native_raycasting.cells_update_visible() end
---@return NativeCellData[]
function native_raycasting.cells_get_visible() end
---@return NativeCellData[]
function native_raycasting.cells_get_need_load() end
---@return NativeCellData[]
function native_raycasting.cells_get_need_unload() end
---@return NativeCellData[]
function native_raycasting.cells_get_need_update() end
---@return NativeCellData
function native_raycasting.cells_get_by_id(id) end
---@return NativeCellData
function native_raycasting.cells_get_by_coords(x, y) end

function native_raycasting.color_hsv_to_rgb(h, s, v) end
function native_raycasting.color_rgb_to_hsv(color) end
function native_raycasting.color_rgb_to_rgbi(r,g,b) end
function native_raycasting.color_rgbi_to_rgb(color) end
function native_raycasting.color_blend_additive(color1,color2) end

function native_raycasting.light_map_set_colors(buffer,size,w,h,colors) end

---@class NativeCellData
local NativeCellData = {}
function NativeCellData:get_x()
end
function NativeCellData:get_y()
end
function NativeCellData:get_visibility() end
function NativeCellData:get_id()
end
function NativeCellData:get_transparent()
end
function NativeCellData:get_blocked()
end
