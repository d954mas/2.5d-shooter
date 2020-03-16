local requiref = require
local lfs = requiref "lfs"
local cjson = requiref "cjson"
local pretty = requiref "resty.prettycjson"

cjson.encode_sparse_array(true)
cjson.decode_invalid_numbers(false)

--Cell used in cpp and in lua.So id start from 0.

---@class TileProperties
---@field width number
---@field height number
---@field size number
---@field ignore_snap_to_grid boolean by default object place in tile center

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

---@class LevelTileset
---@field first_gid number
---@field end_gid number
---@field name string

---@class LevelTilesets
---@field by_id LevelMapTile[]
---@field tilesets LevelTileset[]

---@class LevelMapTileProperties
---@field blocked boolean
---@field transparent boolean

---@class LevelMapTile
---@field properties LevelMapTileProperties
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
---@field floor number|nil nil if no floor. Tile id if have
---@field ceil number|nil nil if no ceil. Tile id if have
---@field native_cell NativeCellData set when load level

--vector3 is not vector3 here. I use it only to autocomplete worked. It will be tables with x,y,z
---@class LevelData
---@field size vector3
---@field floor LevelDataCellFloor[]
---@field ceil LevelDataCellFloor[]
---@field light_map number[]

