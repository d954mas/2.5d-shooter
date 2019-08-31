--vips need 64bit luajit
package.path = 'C:\\Users\\user\\development\\luapower-all-master\\?.lua;' .. package.path
package.cpath = 'C:\\Users\\user\\development\\luapower-all-master\\bin\\mingw64\\clib\\?.dll;' .. package.cpath

local requiref = require
local LFS = requiref "lfs"
local VIPS = requiref "vips"

local IMAGES_WALL_PATH = "\\..\\images\\game\\walls\\"
local RESULT_WALL_PATH = "\\tilesets\\walls\\"

local IMAGES_DOOR_PATH = "\\..\\images\\game\\doors\\"
local RESULT_DOOR_PATH = "\\tilesets\\doors\\"

local IMAGES_THIN_PATH = "\\..\\images\\game\\thin_wall\\"
local RESULT_THIN_PATH = "\\tilesets\\thin_walls\\"

--https://github.com/libvips/lua-vips

local function process_image(path,result_path)
	local name = path:match("^.+\\(.+)")
	result_path = result_path .. "\\" .. name
	local img_base = VIPS.Image.new_from_file(path)
	local size = math.min(64,img_base:width(),img_base:height())
	local image = VIPS.Image.thumbnail(path, size)

	if img_base:width() > 64 or img_base:height()>64 then
		local img_total = VIPS.Image.black(img_base:width(), img_base:height())
		if image:bands() == 3 then image = image:bandjoin(255) end
		img_total = img_total:insert(image, 0, img_base:height()-image:height())
		image = img_total
	end

	image:write_to_file(result_path)

end



local function process_thin_walls(path,result_path)
	local name = path:match("^.+\\(.+)....")
	local img_base = VIPS.Image.new_from_file(path)
	if img_base:bands() == 3 then img_base = img_base:bandjoin(255) end
	local size = 64

	local image = VIPS.Image.thumbnail(path, size,{height  = size/2,size = 3 })
	local image_top = image:copy()
	if image_top:bands() == 3 then image_top = image_top:bandjoin(255) end
	image_top = image_top:embed(0, 16, image_top:width(), 64)
	image_top:write_to_file(result_path .. "" .. name .. "_horizontal.png")


	image = VIPS.Image.thumbnail(path, size,{height  = size/2,size = 3 })
	local image_right = image:copy()
	if image_right:bands() == 3 then image_right = image_right:bandjoin(255) end
	image_right = image_right:embed(0, 16, image_right:width(), 64)
	image_right = image_right:rot(math.rad(90))
	image_right:write_to_file(result_path .. "" .. name .. "_vertical.png")


end

print("Create walls thumbnail")
for file in LFS.dir( LFS.currentdir() .. IMAGES_WALL_PATH) do
	if file ~= "." and file ~= ".." then
		print("image:" .. file)
		process_image(LFS.currentdir() .. "\\" .. IMAGES_WALL_PATH .. "\\" .. file,LFS.currentdir() .. RESULT_WALL_PATH)
	end
end

print("Create doors thumbnail")
for file in LFS.dir( LFS.currentdir() .. IMAGES_DOOR_PATH) do
	if file ~= "." and file ~= ".." then
		print("image:" .. file)
		process_image(LFS.currentdir() .. "\\" .. IMAGES_DOOR_PATH .. "\\" .. file,LFS.currentdir() .. RESULT_DOOR_PATH)
	end
end

print("Create thin walls thumbnail")
for file in LFS.dir( LFS.currentdir() .. IMAGES_THIN_PATH) do
	if file ~= "." and file ~= ".." then
		print("image:" .. file)
		process_thin_walls(LFS.currentdir() .. "\\" .. IMAGES_THIN_PATH .. "\\" .. file,LFS.currentdir() .. RESULT_THIN_PATH)
	end
end

