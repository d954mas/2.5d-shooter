--vips need 64bit luajit
package.path = 'C:\\Users\\user\\development\\luapower-all-master\\?.lua;' .. package.path
package.cpath = 'C:\\Users\\user\\development\\luapower-all-master\\bin\\mingw64\\clib\\?.dll;' .. package.cpath

local requiref = require
local LFS = requiref "lfs"
local VIPS = requiref "vips"

local IMAGES_WALL_PATH = "\\..\\images\\game\\walls\\"
local RESULT_WALL_PATH = "\\tilesets\\walls\\"

local IMAGES_THIN_PATH = "\\..\\images\\game\\thin_wall\\"
local RESULT_THIN_PATH = "\\tilesets\\thin_walls\\"

--https://github.com/libvips/lua-vips

local function process_image(path,result_path)
	local name = path:match("^.+\\(.+)")
	result_path = result_path .. "\\" .. name
	local image = VIPS.Image.thumbnail(path, 64)
	image:write_to_file(result_path)

end

print("Create walls thumbnail")
for file in LFS.dir( LFS.currentdir() .. IMAGES_WALL_PATH) do
	if file ~= "." and file ~= ".." then
		print("image:" .. file)
		process_image(LFS.currentdir() .. "\\" .. IMAGES_WALL_PATH .. "\\" .. file,LFS.currentdir() .. RESULT_WALL_PATH)
	end
end

print("Create thin walls thumbnail")
for file in LFS.dir( LFS.currentdir() .. IMAGES_THIN_PATH) do
	if file ~= "." and file ~= ".." then
		print("image:" .. file)
		process_image(LFS.currentdir() .. "\\" .. IMAGES_THIN_PATH .. "\\" .. file,LFS.currentdir() .. RESULT_THIN_PATH)
	end
end

