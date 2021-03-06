package.path = package.path .. ';C:\\Users\\d954m\\IdeaProjects\\2.5d-shooter_new\\?.lua'

local requiref = require
local lfs = requiref "lfs"
local cjson = requiref "cjson"
local pretty = requiref "resty.prettycjson"
local MAP_HELPER = requiref "assets.levels.parser.map_helper"
local LUME = requiref "libs.lume"

local LEVELS_PATH = "lua"
local TILESETS_PATH = "tilesets"
local RESULT_PATH = "result"
local NEED_PRETTY = false

cjson.encode_sparse_array(true)
cjson.decode_invalid_numbers(false)

local FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
local FLIPPED_VERTICALLY_FLAG = 0x40000000;
local FLIPPED_DIAGONALLY_FLAG = 0x20000000;

---@type LevelTilesets
local TILESETS

local function parse_tilesets(path)
	assert(path)
	print("parse tilesets")
	assert(not TILESETS, "tileset already loaded")

	local tiled = dofile(path)
	local id_to_tile = {}
	local tilesets = {}
	for _, tileset in ipairs(tiled.tilesets) do
		print("parse tileset:" .. tileset.name)
		assert(not tilesets[tileset.name], "tileset with name:" .. tileset.name .. " already created")
		tilesets[tileset.name] = { first_gid = tileset.firstgid, end_gid = tileset.firstgid + tileset.tiles[#tileset.tiles].id, name = tileset.name,
								   properties = tileset.properties or {} }
		for _, tile in ipairs(tileset.tiles) do
			---@type TileProperties
			tile.properties = tile.properties or {}
			id_to_tile[tile.id + tileset.firstgid] = tile
			tile.id = tile.id + tileset.firstgid
			tile.width = tile.width or tile.size or tileset.tilewidth
			tile.height = tile.height or tile.size or tileset.tileheight
			if (tile.angle) then tile.angle = math.rad(tile.angle) end
			if (tile.rotation_speed) then tile.rotation_speed = math.rad(tile.rotation_speed) end
			if (tile.fov) then tile.fov = math.rad(tile.fov) end
			if (tile.properties.wall_animation) then
				local json_str = tile.properties.wall_animation
				tile.properties.wall_animation = cjson.decode(tile.properties.wall_animation)
				assert(tile.properties.wall_animation.animation,"bad animation:" .. json_str)
			end
			--copy tileset properties to tile properties
			setmetatable(tile.properties, { __index = tileset.properties })
			if tile.image then
				local image_path = tile.image
				local pathes = {}
				for word in string.gmatch(image_path, "([^/]+)") do
					table.insert(pathes, word)
				end
				tile.atlas = pathes[#pathes - 1]
				tile.image = string.sub(pathes[#pathes], 1, string.find(pathes[#pathes], "%.") - 1)
				--[[if tile.properties.thin_wall then
					local idx = string.find(tile.image, "_[^_]*$")
					local orientation =  string.sub(tile.image,idx+1)
					local angle = 0
					if orientation == "horizontal" then angle = 0
					elseif orientation == "vertical" then angle = 90
					else assert(nil,"unknown thin wall orientation:" .. tostring(orientation)) end
					tile.image =  string.sub(tile.image,1,idx - 1)
					tile.atlas = "wall"
					if not tile.properties.angle then
						tile.properties.angle = angle
					end
				end--]]
			end--]]
			tile.scale = 1 / (tile.properties.texture_size or tile.height) * (tile.properties.scale or 1)
			--[[local origin = tile.properties.origin
			if origin then
				local size = tile.properties.size_for_scale or tile.height
				local dy = (size - tile.height)*tile.scale
				if origin == "top" then tile.origin = {x=0,y=dy} end
			end--]]
		end
	end
	TILESETS = { by_id = id_to_tile, tilesets = tilesets }
	print("parse tilesets done")
end

---@return LevelData
local function create_map_data(tiled)
	local data = {}
	data.size = { x = tiled.width, y = tiled.height }
	data.properties = tiled.properties
	return data
end

--Check that id same for cells
--Use same id for cell in all maps
local function check_tilesets(tiled)
	local layers_new_data = {}
	for _, tileset in ipairs(tiled.tilesets) do
		if tileset.firstgid ~= TILESETS.tilesets[tileset.name].first_gid then
			print("    update tileset:" .. tileset.name)
			local end_gid = tileset.firstgid + tileset.tiles[#tileset.tiles].id
			for _, layer in ipairs(tiled.layers) do
				local new_data = layers_new_data[layer] or {}
				layers_new_data[layer] = new_data
				local firstgid_delta = TILESETS.tilesets[tileset.name].first_gid - tileset.firstgid
				if layer.data then
					for i, v in ipairs(layer.data) do
						if v >= tileset.firstgid and v <= end_gid then
							assert(not new_data[i], "cell already processed")
							new_data[i] = layer.data[i] + firstgid_delta
							layer.data[i] = -1 --processed cell
						end
					end
				end
				if layer.objects then
					for _, obj in ipairs(layer.objects) do
						if not obj._tileset_processed and obj.gid >= tileset.firstgid and obj.gid <= end_gid then
							obj.gid = obj.gid + firstgid_delta
							obj._tileset_processed = true
						end
					end
				end
			end
		end
	end
	for _, layer in ipairs(tiled.layers) do
		local new_data = layers_new_data[layer]
		if new_data then
			for idx, v in pairs(new_data) do
				assert(layer.data[idx] == -1, "can't set for unprocessed cell")
				layer.data[idx] = v
			end
		end
		if layer.objects then
			for _, obj in ipairs(layer.objects) do
				obj._tileset_processed = nil
			end
		end
	end
end

--region repack
--change Y-down to Y-top
local function repack_layer(array, tiled, map)
	assert(array)
	assert(tiled)
	local width = tiled.width
	local height = #array / width
	local cells = {}
	for y = 1, height do
		for x = 1, width do
			local tiled_cell = assert(array[(y - 1) * width + x])
			local new_coords = (height - y) * width + x
			cells[new_coords] = tiled_cell
		end
	end
	assert(#cells == #array)
	for i = 1, #cells do
		array[i] = cells[i]
	end
end

--change Y-down to Y-top
--make some precalculation
local function repack_objects(array, tiled, map)
	assert(array)
	assert(tiled)
	local total_height = tiled.height * tiled.tileheight
	for i, object in ipairs(array) do
		local x, y = object.x, object.y
		y = total_height - y
		object.x, object.y = x, y
		assert(object.rotation == 0, "object rotation should be 0.Use flip when need")
		local object_data = { tile_id = object.gid, properties = object.properties or {}, x = object.x, y = object.y, w = object.width, h = object.height }
		local tile = TILESETS.by_id[object_data.tile_id]
		if tile then
			setmetatable(object_data.properties, { __index = tile.properties })
		end
		--objects use center of cell as it pos. By default
		if not (object_data.properties.ignore_center_default) then
			object_data.x = object_data.x + tiled.tilewidth / 2
			object_data.y = object_data.y + tiled.tileheight / 2
		end

		object_data.cell_xf = object_data.x / tiled.tilewidth
		object_data.cell_yf = object_data.y / tiled.tileheight
		--	object_data.cell_w = object_data.w / tiled.tilewidth
		--object_data.cell_h = object_data.h / tiled.tileheight
		object_data.cell_x = math.floor(object_data.x / tiled.tilewidth)
		object_data.cell_y = math.floor(object_data.y / tiled.tileheight)
		--object_data.cell_center_x = object_data.cell_xf + object_data.cell_w/2
		--object_data.cell_center_y = object_data.cell_yf + object_data.cell_h/2
		object_data.cell_id = MAP_HELPER.coords_to_id(map, object_data.cell_x, object_data.cell_y)
		if (rawget(object_data.properties, "angle")) then object_data.properties.angle = math.rad(object_data.properties.angle) end
		if (rawget(object_data.properties, "rotation_speed")) then object_data.properties.rotation_speed = math.rad(object_data.properties.rotation_speed) end
		if (rawget(object_data.properties, "fov")) then object_data.properties.fov = math.rad(object_data.properties.fov) end

		array[i] = object_data
	end
end

local function repack_all(tiled, map)
	for _, l in ipairs(tiled.layers) do
		if l.data then repack_layer(l.data, tiled, map) end
		if l.objects then repack_objects(l.objects, tiled, map) end
	end
end

local function get_layer(tiled, layer_name)
	for _, l in ipairs(tiled.layers) do if l.name == layer_name then return l end end
	return nil
end

---@param tilesets LevelTileset[]
local function check_layer_tilesets(layer, tilesets, no_empty)
	if layer.data then
		for _, tile in ipairs(layer.data) do
			local success = false
			if (tile == 0 and no_empty) then
				assert("bad tile:0")
			else
				success = true
			end

			for _, tileset in ipairs(tilesets) do
				if (tile >= tileset.first_gid and tile <= tileset.end_gid) then
					success = true
					break
				end
			end

			assert(success, "bad tile:" .. tile)
		end
	end

	if layer.objects then
		for _, object in ipairs(layer.objects) do
			local success = false
			for _, tileset in ipairs(tilesets) do
				if (object.tile_id >= tileset.first_gid and object.tile_id <= tileset.end_gid) then
					success = true
					break
				end
			end
			assert(success, "bad object:" .. object.tile_id)
		end
	end
end

local function tile_to_data(tile_id)
	local flipped_horizontally = bit.band(bit.tobit(tile_id), FLIPPED_HORIZONTALLY_FLAG) ~= 0;
	local flipped_vertically = bit.band(bit.tobit(tile_id), FLIPPED_VERTICALLY_FLAG) ~= 0;
	local flipped_diagonally = bit.band(bit.tobit(tile_id), FLIPPED_DIAGONALLY_FLAG) ~= 0;

	if (not flipped_horizontally) then flipped_horizontally = nil end
	if (not flipped_vertically) then flipped_vertically = nil end
	if (not flipped_diagonally) then flipped_diagonally = nil end

	tile_id = bit.band(tile_id, bit.bnot(bit.bor(FLIPPED_HORIZONTALLY_FLAG, FLIPPED_VERTICALLY_FLAG, FLIPPED_DIAGONALLY_FLAG)));
	return { tile_id = tile_id, fh = flipped_horizontally, fv = flipped_vertically, fd = flipped_diagonally }
end

---@param map LevelData
local function parse_floor(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["walls"]) })
	local result = {}
	for i, tile in ipairs(layer.data) do

		if tile ~= 0 then result[i] = tile_to_data(tile) end
	end
	return result
end

---@param map LevelData
local function parse_walls(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["walls"]) })
	local result = {}
	for i, tile in ipairs(layer.data) do
		if (tile ~= 0) then result[i] = { base = tile_to_data(tile) } end
	end
	return result
end

local function parse_light_map(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["lights"]) })
	local result = {}
	for i, v in ipairs(layer.data) do
		result[i] = v == 0 and -1 or tonumber("0x" .. string.sub(TILESETS.by_id[v].properties.color, 2))
	end
	return result
end

---@param map LevelData
local function parse_objects(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["objects"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	for _, obj in ipairs(objects) do
		if (obj.properties.player) then
			assert(not map.player, "player position already set")
			map.player = {
				position = { x = obj.cell_xf, y = obj.cell_yf },
				angle = assert(obj.properties.angle)
			}
		else
			error("unknown object")
		end
	end
end

local function parse_level_objects(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["level_objects"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	local result = {}
	for _, obj in ipairs(objects) do
		table.insert(result, obj)
	end
	return result;
end

local function parse_light_sources(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["light_sources"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	local result = {}
	for _, obj in ipairs(objects) do
		local type = obj.properties.light_type
		assert(type == "point", "unknown light type:" .. tostring(type))
		assert(obj.properties.light_color)
		local color = LUME.string_split(LUME.string_trim(obj.properties.light_color), ";")
		assert(#color == 3, "bad color split:" .. obj.properties.light_color)
		local h, s, v = tonumber(color[1]), tonumber(color[2]), tonumber(color[3])
		assert(h >= 0 and h <= 360)
		assert(s >= 0 and s <= 1)
		assert(v >= 0 and v <= 1)
		obj.properties.light_color = { h = h, s = s, v = v }
		table.insert(result, obj)

		if (obj.properties.light_pattern) then
			local data = assert(cjson.decode(obj.properties.light_pattern), "bad json:" .. obj.properties.light_pattern)
			assert(data.type)
			obj.properties.light_pattern = data
			--@TODO add move validations
		end
	end
	return result;
end

local function parse_pickups(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["pickups"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	local result = {}
	for _, obj in ipairs(objects) do
		assert(obj.properties.pickup_type)
		table.insert(result, obj)
	end
	return result;
end

local function parse_doors(map, layer)
	check_layer_tilesets(layer, { assert(TILESETS.tilesets["doors"]) })
	assert(layer.objects)
	---@type LevelMapObject[]
	local objects = layer.objects
	local result = {}
	for _, obj in ipairs(objects) do
		assert(obj.properties.door)
		table.insert(result, obj)
	end
	return result;
end

---@param map LevelData
local function check(map)
	assert(map.player, "no player")
	assert(map.level_objects, "no player")
end

local function parse_level(path, result_path)
	local name = path:match("^.+\\(.+)....")
	result_path = result_path .. "\\" .. name .. ".json"
	local tiled = dofile(path)
	tiled.src = path
	local data = create_map_data(tiled)
	check_tilesets(tiled)
	repack_all(tiled, data)
	data.floor = parse_floor(data, assert(get_layer(tiled, "floor")))
	data.ceil = parse_floor(data, assert(get_layer(tiled, "ceil")))
	data.walls = parse_walls(data, assert(get_layer(tiled, "walls")))
	data.light_map = parse_light_map(data, assert(get_layer(tiled, "light_map")))
	parse_objects(data, assert(get_layer(tiled, "objects")))
	data.level_objects = parse_level_objects(data, assert(get_layer(tiled, "level_objects")))
	data.light_sources = parse_light_sources(data, assert(get_layer(tiled, "light_sources")))
	data.pickups = parse_pickups(data, assert(get_layer(tiled, "pickups")))
	data.doors = parse_doors(data, assert(get_layer(tiled, "doors")))

	check(data)
	--[[
		local wall_keys = { "north", "south", "east", "west" }
		process_layer(data, assert(get_layer(tiled, "walls")), function(cell, tiled_cell, x, y)
			local tile = assert(TILESET.by_id[tiled_cell], "unknown tile:" .. tiled_cell)
			if tile.properties.wall then
				cell.wall["base"] = tiled_cell
				for _, v in pairs(wall_keys) do
					cell.wall[v] = tiled_cell
				end
				cell.blocked = tile.properties.block;
			elseif tile.properties.thin_wall then
				cell.wall["thin"] = tiled_cell
				cell.blocked = tile.properties.block;
			elseif tile.properties.door then
				--doors do not mark cell is blocked. It will be marked as blocked when load level
				table.insert(data.doors, create_object_from_tile(tiled, tiled_cell, x - 0.5, y - 0.5))
			else
				assert(nil, "unknown tile:" .. tiled_cell)
			end

		end)
		for y = 1, data.size.y do
			local row = assert(data.cells[y])
			for x = 1, data.size.x do
				local cell = assert(row[x])
				cell.empty = is_wall_empty(cell.wall)
			end
		end
		data.light_map = {}
		for k, v in ipairs(get_layer(tiled, "lights").data) do
			data.light_map[k] = v == 0 and 0xFFFFFFFF or tonumber("0x" .. string.sub(TILESET.by_id[v].properties.color, 2))
		end
		process_objects(assert(get_layer(tiled, "objects"), "no objects layer"), function(object)
			if object.properties.spawn_point then
				assert(not data.spawn_point, "spawn point already set")
				data.spawn_point = { x = object.cell_xf, y = object.cell_yf, angle = object.properties.rotation }
			else
				assert(not object.properties.pickup, "pickup on objects layer")
				assert(not object.properties.enemy, "enemy on objects layer")
				table.insert(data.objects, object)
			end
		end)
		process_objects(assert(get_layer(tiled, "enemies"), "no enemies layer"), function(object)
			assert(object.properties.enemy, "should be enemy:" .. tostring(object.tile_id))
			if object.properties.spawner then
				table.insert(data.spawners, object)
			else
				table.insert(data.enemies, object)
			end
		end)
		process_objects(assert(get_layer(tiled, "pickups"), "no pickups layer"), function(object)
			assert(object.properties.pickup, "should be pickup:" .. tostring(object.tile_id))
			table.insert(data.pickups, object)
		end)

		clean_map(data)

		--region validations
		assert(data.spawn_point, "no spawn point")
		--endregion
		--]]

	local json = NEED_PRETTY and pretty(data, nil, "  ", "") or cjson.encode(data)
	local file = assert(io.open(result_path, "w+"))
	file:write(json)
	file:close()
end

parse_tilesets(lfs.currentdir() .. "\\" .. TILESETS_PATH .. "\\" .. "tilesets.lua")
local json = NEED_PRETTY and pretty(TILESETS, nil, "  ", "") or cjson.encode(TILESETS)
local file_save = assert(io.open(lfs.currentdir() .. "\\" .. RESULT_PATH .. "\\" .. "tileset.json", "w+"))
file_save:write(json)
file_save:close()

for file in lfs.dir(lfs.currentdir() .. "\\" .. LEVELS_PATH) do
	if file ~= "." and file ~= ".." then
		print("parse level:" .. file)
		parse_level(lfs.currentdir() .. "\\" .. LEVELS_PATH .. "\\" .. file, lfs.currentdir() .. "\\" .. RESULT_PATH .. "\\")
	end
end