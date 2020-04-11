--Cell used in cpp and in lua.So id start from 0.

---@class ColorHSV
---@field h number
---@field s number
---@field v number

---@class TileProperties
---@field width number
---@field tag string
---@field height number
---@field size number
---@field ignore_snap_to_grid boolean by default object place in tile center
---@field texture_size number used to find scale of object.
---@field sprite_origin_y number used to correctly set origin for sprite
---@field position_z number default z position
---@field blocked boolean
---@field transparent boolean
---@field light boolean
---@field light_type string point
---@field light_distance number
---@field light_color ColorHSV
---@field rays number
---@field fov number
---@field angle number

---@class LevelMapObject
---@field tile_id number
---@field properties TileProperties
---@field x number
---@field y number
---@field cell_x number int
---@field cell_y number int
---@field cell_xf number float
---@field cell_yf number float
---@field cell_id number int
---@field cell_w number float
---@field cell_h number float

---@class LevelTileset
---@field first_gid number
---@field end_gid number
---@field name string

---@class LevelTilesets
---@field by_id LevelMapTile[]
---@field tilesets LevelTileset[]


---@class LevelMapTile
---@field properties TileProperties
---@field id number
---@field width number
---@field height number
---@field atlas string
---@field image string
---@field image_hash hash
---@field scale number


---@class LevelDataCellFloor
---@field tile_id number

---@class LevelDataWallBlock
---@field base number one base  tile id
---@field north number|nil  nil if same as base or new tile id
---@field south number|nil
---@field east number|nil
---@field west number|nil
---@field native_cell NativeCellData set when load level


---@class LevelDataPlayer
---@field position vector3
---@field angle number

--vector3 is not vector3 here. I use it only to autocomplete worked. It will be tables with x,y,z
---@class LevelData
---@field size vector3
---@field floor LevelDataCellFloor[]
---@field ceil LevelDataCellFloor[]
---@field walls LevelDataWallBlock[]
---@field light_map number[]
---@field player LevelDataPlayer
---@field level_objects LevelMapObject[]
---@field light_sources LevelMapObject[]

