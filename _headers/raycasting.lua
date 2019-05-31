native_raycasting = {}

function native_raycasting.camera_update(x,y,angle) end
function native_raycasting.camera_set_fov(fov) end
function native_raycasting.camera_set_rays(rays) end
function native_raycasting.camera_set_max_distance(max_distance) end

---@param level_data LevelData
function native_raycasting.map_set(level_data) end
function native_raycasting.map_find_path(x,y,x2,y2) end

function native_raycasting.cells_update_visible() end
function native_raycasting.cells_get_visible() end
