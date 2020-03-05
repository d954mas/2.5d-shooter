local M = {}


--- Get the full path to a save file
-- @param name Name of file to get full path for
-- @return The full path to the specified file
function M.get_save_file_name(name)
	local application_name = sys.get_config("project.title"):gsub(" ", "_")
	return sys.get_save_file(application_name, name)
end


--- Load a file from disk
-- @param name Name of file to load
-- @return contents File contents or nil if file could not be read
-- @return error_message Error message if file could not be read
function M.load(name)
	assert(name, "You must provide a file name")
	local filename = M.get_save_file_name(name)
	local file, err = io.open(filename, "r")
	if not file then
		return nil, err
	end
	local contents = file:read("*a")
	if not contents then
		return nil, "Unable to read file"
	end
	return contents
end


--- Save a file to disk
-- Saves are atomic and first written to a temporary file
-- If the file already exists it will be overwritten
-- @param name Name of file to write data to
-- @param data The data to write
-- @return success
-- @return error_message
function M.save(name, data)
	assert(name, "You must provide a file name")
	assert(data, "You must provide some data")
	assert(type(data) == "string", "You can only write strings")
	local tmpname = M.get_save_file_name("__ga_tmp")
	local file, err = io.open(tmpname, "w+")
	if not file then
		return nil, err
	end
	file:write(data)
	file:close()

	local filename = M.get_save_file_name(name)
	os.remove(filename)
	return os.rename(tmpname, filename)
end

return M