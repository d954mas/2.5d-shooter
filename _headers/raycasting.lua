native_raycasting = {}

---@return NativeCamera
function native_raycasting.camera_new() end
function native_raycasting.camera_delete(camera) end
function native_raycasting.camera_set_main(camera) end
function native_raycasting.camera_cast_rays(camera, blocking) end

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
function native_raycasting.color_rgb_to_rgbi(r, g, b) end
function native_raycasting.color_rgbi_to_rgb(color) end
function native_raycasting.color_blend_additive(color1, color2) end

function native_raycasting.light_map_set_colors(buffer, size, w, h, colors) end

---@class NativeCellData
local NativeCellData = {}
function NativeCellData:get_x() end
function NativeCellData:get_y() end
function NativeCellData:get_visibility() end
function NativeCellData:get_id() end
function NativeCellData:get_transparent() end
function NativeCellData:get_blocked() end

---@class NativeCamera
local NativeCamera = {}
function NativeCamera:get_pos() end
function NativeCamera:set_pos(x, y) end
function NativeCamera:set_angle(angle) end
function NativeCamera:set_rays(rays) end
function NativeCamera:set_fov(fov) end
function NativeCamera:set_view_dist(view_dist) end
function NativeCamera:set_max_dist(max_dist) end
