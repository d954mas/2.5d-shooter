local requiref = require
local lfs = requiref "lfs"
local cjson = requiref "cjson"
local pretty = requiref "resty.prettycjson"

local NEED_PRETTY = true
cjson.encode_sparse_array(true)
cjson.decode_invalid_numbers(false)

--Cell used in cpp and im lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0

---@class LevelDataCellObjects
---@field north table
---@field south table
---@field east table
---@field west table
---@field floor table
---@field cell table


---@class LevelDataCellWall
---@field north number if -1 then no wall
---@field south number
---@field east number
---@field west number
---@field floor number
---@field ceil number
local LevelDataCellWalls = {}


--Draw only north/south east/west.
--If need draw always add to other
---@class LevelDataCell
---@field position vector3
---@field id number
---@field wall LevelDataCellWall
---@field objects LevelDataCellObjects[]
---@field blocked boolean
local LevelDataCell = {}


--vector3 is not vector3 here. I use it only to autocomplete worked. It will be tables with x,y,z
---@class LevelData
---@field size vector3
---@field id_to_tile table
---@field spawn_point vector3
---@field spawn_point vector3
---@field cells LevelDataCell[][]
local LevelData = {}

local function create_empty_cell(x,y)
	local cell = {}
	cell.position = {x=x or 0,y = y or y}
	cell.wall ={ north = -1,south = -1,east = -1, west = -1, floor = -1, ceil = -1 }
	cell.objects = {}
	return cell
end

local function get_layer(tiled, layer_name)
	for _,l in ipairs(tiled.layers) do if l.name == layer_name then return l end end
end

local function repack_layer(array,tiled)
	assert(array)
	assert(tiled)
	local width = tiled.width
	local height = #array/width
	local cells = {}
	for y=1,height do
		for x=1,width do
			local tiled_cell = assert(array[(y-1)*width + x])
			local new_coords = (height-y)*width + x
			cells[new_coords] = tiled_cell
		end
	end
	assert(#cells == #array)
	for i=1,#cells do
		array[i]=cells[i]
	end
end

local function repack_objects(array,tiled)
	assert(array)
	assert(tiled)
	local total_height = tiled.height*tiled.tileheight
	for _,object in ipairs(array)do
		local x,y = object.x, object.y
		y = total_height-y
		object.x, object.y = x,y
		object.cell_x = math.ceil(x/tiled.tilewidth)
		object.cell_y = math.ceil(x/tiled.tileheight)
	end
end


local function process_layer(data,layer,fun)
	for y=1,data.size.y do
		local row = assert(data.cells[y])
		for x=1,data.size.x do
			local cell = assert(row[x])
			local tiled_cell = assert(layer.data[(y-1)*data.size.x + x])
			if tiled_cell ~= 0 then fun(cell,tiled_cell-1) end
		end
	end
end

local function parse_level(path,result_path)
	--print("path:" .. path)
	--print("result:" .. result_path)
	local name = path:match("^.+\\(.+)....")
	result_path = result_path .. "\\" .. name .. ".json"
	local tiled = dofile(path)
	local data = {}
	data.size = {x=tiled.width,y = tiled.height}
	data.properties = tiled.properties
	data.cells = {}
	data.tilesets = {}
	data.id_to_tile = {}
	for _, tileset in ipairs(tiled.tilesets)do
		table.insert(data.tilesets,{name = tileset.name,firstgid = tileset.firstgid})
		for _,tile in ipairs(tileset.tiles) do
			data.id_to_tile[tileset.firstgid+tile.id-1] = tile
			local image_path = tile.image
			local pathes = {}
			for word in string.gmatch(image_path, "([^/]+)") do
				table.insert(pathes,word)
			end
			tile.atlas = pathes[#pathes-1]
			tile.image = string.sub(pathes[#pathes],1,string.find(pathes[#pathes],"%.")-1)
		end
	end
	for y=1,data.size.y do
		data.cells[y] = {}
		local row = data.cells[y]
		for x=1,data.size.x do
			local cell = assert(create_empty_cell(x,y))
			cell.id = (y-1)* data.size.x + x
			row[x] = cell
		end
	end
	for _,l in ipairs(tiled.layers) do
		if l.data then repack_layer(l.data,tiled) end
		if l.objects then repack_objects(l.objects,tiled) end
	end

	process_layer(data,assert(get_layer(tiled,"floor")),function(cell,tiled_cell) cell.wall.floor = tiled_cell end)
	local wall_keys = {"north","south","east","west"}
	process_layer(data,assert(get_layer(tiled,"walls")),function(cell,tiled_cell) for _,v in pairs(wall_keys)do
			cell.wall[v] = tiled_cell
			if true then --for now all walls are blocking
				cell.blocked = true;
			end
		end
	end)
	local objects = assert(get_layer(tiled,"objects")).objects
	for _,object in ipairs(objects)do
		if object.properties.spawn_point then
			assert(not data.spawn_point,"spawn point already set")
			data.spawn_point = {x=object.cell_x,y=object.cell_y}
		end
	end

	--region validations
	assert(data.spawn_point,"no spawn point")


	--endregion

	local json = NEED_PRETTY and pretty(data,nil,"  ","") or cjson.encode(data)
	local file = assert(io.open(result_path, "w+"))
	file:write(json)
	file:close()
end

local LEVELS_PATH = "lua"
local RESULT_PATH = "result"
for file in lfs.dir( lfs.currentdir() .. "\\" .. LEVELS_PATH) do
	if file ~= "." and file ~= ".." then
		print("parse level:" .. file)
		parse_level( lfs.currentdir() .. "\\" .. LEVELS_PATH .. "\\" .. file , lfs.currentdir() .. "\\" .. RESULT_PATH .. "\\")
	end
end
