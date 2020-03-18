---@type LevelTilesets
local TILESET

TILESET = json.decode(assert(sys.load_resource("/assets/levels/result/tileset.json"), "no tileset"))
for k, v in pairs(TILESET.tilesets) do
	v.properties = v.properties or {}
	local meta = { __index = v.properties }
	for i = v.first_gid, v.end_gid, 1 do
		local tile = TILESET.by_id[i]
		if (tile) then
			if tile.image then tile.image_hash = hash(tile.image) end
			tile.properties = tile.properties or {}
			setmetatable(tile.properties, meta)
		end
	end
end

return TILESET