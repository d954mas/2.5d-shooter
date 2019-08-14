local requiref = require
local lfs = requiref "lfs"
local cjson = requiref "cjson"
local pretty = requiref "resty.prettycjson"
local NEED_PRETTY = true
local TILESET
cjson.encode_sparse_array(true)
cjson.decode_invalid_numbers(false)

--Cell used in cpp and im lua.
--In lua id start from 1 in cpp from 0
--In lua pos start from 1 in cpp from 0

---@class LevelDataTile
---@field properties table
---@field id number
---@field width number
---@field height number
---@field atlas string
---@field image string|hash
---@field scale number

---@class LevelDataObject
---@field tile_id number
---@field properties table
---@field x number
---@field y number
---@field cell_xf number
---@field cell_yf number
---@field cell_x number
---@field cell_y number
---@field cell_id number


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

---@class LevelDataCell
---@field position vector3
---@field id number
---@field wall LevelDataCellWall
---@field objects LevelDataCellObjects[]
---@field blocked boolean
---@field empty boolean

--vector3 is not vector3 here. I use it only to autocomplete worked. It will be tables with x,y,z
---@class LevelData
---@field size vector3
---@field id_to_tile table
---@field spawn_point vector3
---@field enemies table[]
---@field cells LevelDataCell[][]
---@field spawners table[]
---@field light_map number[]

local function clone_deep(t)
	local orig_type = type(t)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, t, nil do
			copy[ clone_deep(orig_key)] =  clone_deep(orig_value)
		end
	else -- number, string, boolean, etc
		copy = t
	end
	return copy
end

local function create_empty_cell(x,y)
	local cell = {}
	cell.position = {x=x or 0,y = y or y}
	cell.wall ={ north = nil,south = nil,east = nil, west = nil, floor = nil, ceil = nil,blocked = true, empty = nil }
	cell.objects = {}
	return cell
end
local function get_layer(tiled, layer_name)
	for _,l in ipairs(tiled.layers) do if l.name == layer_name then return l end end
	return nil
end
local function process_layer(data,layer,fun)
	for y=1,data.size.y do
		local row = assert(data.cells[y])
		for x=1,data.size.x do
			local cell = assert(row[x])
			local tiled_cell = assert(layer.data[(y-1)*data.size.x + x])
			if tiled_cell ~= 0 then fun(cell,tiled_cell) end
		end
	end
end
local function process_objects(layer,fun)
	for _,object in ipairs(layer.objects)do
		fun(object)
	end
end
local function coords_to_id(tiled,x,y)
	return (y-1)* tiled.width + x
end

--region repack
--change Y-down to Y-top
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

--change Y-down to Y-top
--make some precalculation
local function repack_objects(array,tiled)
	assert(array)
	assert(tiled)
	local total_height = tiled.height*tiled.tileheight
	for i,object in ipairs(array)do
		local x,y = object.x, object.y
		y = total_height-y
		object.x, object.y = x,y
		local object_data = { tile_id = object.gid, properties = object.properties,x = object.x, y = object.y }
		--copy properties from tile.
		local tile = TILESET[object_data.tile_id]
		if tile then
			for k,v in pairs(tile.properties)do
				if object_data.properties[k] == nil	then
					object_data.properties[k] = v
				end
			end
		end
		--objects use center of cell as it pos. By default
		if not (object_data.properties.ignore_snap_to_grid) then
			object_data.x = object_data.x + tiled.tilewidth/2
			object_data.y = object_data.y + tiled.tileheight/2
		end
		object_data.cell_xf = object_data.x/tiled.tilewidth
		object_data.cell_yf = object_data.y/tiled.tileheight
		object_data.cell_x = math.ceil(object_data.x/tiled.tilewidth)
		object_data.cell_y = math.ceil(object_data.y/tiled.tileheight)
		object_data.cell_id = coords_to_id(tiled,object_data.cell_x ,object_data.cell_y)
		array[i] = object_data
	end
end

local function repack_all(tiled)
	for _,l in ipairs(tiled.layers) do
		if l.data then repack_layer(l.data,tiled) end
		if l.objects then repack_objects(l.objects,tiled) end
	end
end

--endregion

local function create_tileset(tiled)
	local id_to_tile = {}
	for _, tileset in ipairs(tiled.tilesets)do
		for _,tile in ipairs(tileset.tiles) do
			tile.properties = tile.properties or {}
			id_to_tile[tile.id + tileset.firstgid] = tile
			tile.id = tile.id + tileset.firstgid
			tile.width = tile.width or tileset.tilewidth
			tile.height = tile.height or tileset.tileheight
			if tile.image then
				local image_path = tile.image
				local pathes = {}
				for word in string.gmatch(image_path, "([^/]+)") do
					table.insert(pathes,word)
				end
				tile.atlas = pathes[#pathes-1]
				tile.image = string.sub(pathes[#pathes],1,string.find(pathes[#pathes],"%.")-1)
			end
			tile.scale = 1/(tile.properties.size_for_scale or tile.height)*(tile.properties.scale or 1)
			local origin = tile.properties.origin
			if origin then
				local size = tile.properties.size_for_scale or tile.height
				local dy = (size - tile.height)*tile.scale
				if origin == "top" then tile.origin = {x=0,y=dy} end
			end
		end
	end
	if not TILESET then
		TILESET = id_to_tile
	else
		local json_global_tileset = cjson.encode(TILESET)
		local json_local_tileset = cjson.encode(id_to_tile)
		if json_global_tileset ~= json_local_tileset then
			print("GLOBAL:" .. json_global_tileset)
			print("LOCAL:" .. json_local_tileset)
			assert(nil,"tileset not equal")
		end
	end
end

local function create_map_data(tiled)
	local data = {}
	data.size = {x=tiled.width,y = tiled.height}
	data.properties = tiled.properties
	data.cells = {}
	data.objects = {}
	data.pickups = {}
	data.enemies = {}
	data.spawners = {}
	for y=1,data.size.y do
		data.cells[y] = {}
		local row = data.cells[y]
		for x=1,data.size.x do
			local cell = assert(create_empty_cell(x,y))
			cell.id = coords_to_id(tiled,x,y)
			row[x] = cell
		end
	end
	return data
end


local function is_transparent(tile)
	return not tile or TILESET[tile].properties.transparent
end

local function is_wall_transparent(wall)
	return is_transparent(wall.north) or is_transparent(wall.south) or
			 is_transparent(wall.west) or is_transparent(wall.east)
end

local function is_wall_empty(wall)
	return not (wall.north or wall.south or wall.west or wall.east or wall.cell or wall.floor)
end

--remove not visible walls
---@param map LevelData
local function clean_map(map)
	--remove floor and ceil
	for y=1,map.size.y do
		for x=1,map.size.x do
			local wall = map.cells[y][x].wall
			if not is_wall_transparent(wall) then
				wall.ceil = nil
				wall.floor = nil
			end
		end
	end
	--remove walls. That user can't see.
	--for example [][] will be [  ]
	--if wall have transparent is draw all parts
	local data = {
		{dx = 1,dy = 0,wall = "east",wall_2 = "west"},
		{dx = 0,dy = 1,wall = "north",wall_2 = "south"}
	}
	---@type LevelData[][]
	local cells_copy = clone_deep(map.cells)
	for _,wall_data in ipairs(data)do
		for y=1,map.size.y do
			local next_row = map.cells[y+wall_data.dy]
			if not next_row then break end
			for x=1,map.size.x do
				local wall = map.cells[y][x].wall
				if not is_wall_transparent(wall) then
					local next_wall = map.cells[y+wall_data.dy][x+wall_data.dx]
					if next_wall and not is_transparent(next_wall.wall[wall_data.wall_2]) then
						cells_copy[y][x].wall[wall_data.wall] = nil
						cells_copy[y+wall_data.dy][x+wall_data.dx].wall[wall_data.wall_2] = nil
					end
				end
			end
		end
	end
	--region remove level edges
	for y=1,map.size.y do
		local remove_first = false
		local last_cell
		for x=1,map.size.x do
			local wall = map.cells[y][x].wall
			local wall_copy = cells_copy[y][x].wall
			if not is_wall_transparent(wall) then
				if not remove_first then
					wall_copy.west = nil
					remove_first = true
				else
					last_cell = wall_copy
				end
			end
		end
		if last_cell then last_cell.east = nil end
	end
	for x=1,map.size.x do
		local remove_first = false
		local last_cell
		for y=1,map.size.y do
			local wall = map.cells[y][x].wall
			local wall_copy = cells_copy[y][x].wall
			if not is_wall_transparent(wall) then
				if not remove_first then
					wall_copy.south = nil
					remove_first = true
				else
					last_cell = wall_copy
				end
			end
		end
		if last_cell then last_cell.north = nil end
	end
	--endregion
	map.cells = cells_copy
end

local function parse_level(path,result_path)
	local name = path:match("^.+\\(.+)....")
	result_path = result_path .. "\\" .. name .. ".json"
	local tiled = dofile(path)
	local data = create_map_data(tiled)
	create_tileset(tiled)
	repack_all(tiled)
	process_layer(data,assert(get_layer(tiled,"floor")),function(cell,tiled_cell) cell.wall.floor = tiled_cell end)
	process_layer(data,assert(get_layer(tiled,"ceil")),function(cell,tiled_cell) cell.wall.ceil = tiled_cell end)
	local wall_keys = {"north","south","east","west"}
	process_layer(data,assert(get_layer(tiled,"walls")),function(cell,tiled_cell) for _,v in pairs(wall_keys)do
			cell.wall[v] = tiled_cell
			local tile = TILESET[tiled_cell]
			cell.blocked = tile.properties.block;
		end
	end)
	for y=1,data.size.y do
		local row = assert(data.cells[y])
		for x=1,data.size.x do
			local cell = assert(row[x])
			cell.empty = is_wall_empty(cell.wall)
		end
	end
	data.light_map = {}
	for k,v in ipairs(get_layer(tiled,"lights").data)do
		data.light_map[k] = v == 0 and 0xFFFFFFFF or tonumber("0x"..string.sub(TILESET[v].properties.color,2))
	end
	process_objects(assert(get_layer(tiled,"objects"),"no objects layer"),function(object)
		if object.properties.spawn_point then
			assert(not data.spawn_point,"spawn point already set")
			data.spawn_point = {x=object.cell_x,y=object.cell_y}
		else
			assert(not object.properties.pickup,"pickup on objects layer")
			assert(not object.properties.enemy,"enemy on objects layer")
			table.insert(data.objects,object)
		end
	end)
	process_objects(assert(get_layer(tiled,"enemies"),"no enemies layer"),function(object)
		assert(object.properties.enemy,"should be enemy:" .. tostring(object.tile_id))
		if object.properties.spawner then
			table.insert(data.spawners,object)
		else
			table.insert(data.enemies,object)
		end
	end)
	process_objects(assert(get_layer(tiled,"pickups"),"no pickups layer"),function(object)
		assert(object.properties.pickup,"should be pickup:" .. tostring(object.tile_id))
		table.insert(data.pickups,object)
	end)

	clean_map(data)

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

local json = NEED_PRETTY and pretty(TILESET,nil,"  ","") or cjson.encode(TILESET)
local file = assert(io.open(lfs.currentdir() .. "\\" .. RESULT_PATH .. "\\" .. "tileset.json", "w+"))
file:write(json)
file:close()
