local M = {}
M.print_f = print
M.appname = "DefoldLog"
M.print = false
M.verbose = false
M.logging = true
M.logging_filename = "app.log"
M.sysinfo = sys.get_sys_info()
M.use_date_for_filename = true
M.use_tag_whitelist = false
M.use_tag_blacklist = false
M.disable_logging_for_release = false
M.is_debug = sys.get_engine_info().is_debug
M.delete_old_logs_days = 10
M.__ID = "subsoap/log" -- this is so sister modules can identify a global log
M.__VERSION = 1 -- if this number changes it means there was a breaking change

M.tag_whitelist =
{
	["none"] = true
}

M.tag_blacklist = {

}

M.NONE = 0
M.TRACE = 10
M.DEBUG = 20
M.INFO = 30
M.WARNING = 40
M.ERROR = 50
M.CRITICAL = 60
M.logging_level = M.DEBUG

M.log_level_names =
	{
	[0] = "NONE ",
	[10] = "TRACE ",
	[20] = "DEBUG ",
	[30] = "INFO ",
	[40] = "WARN ",
	[50] = "ERROR ",
	[60] = "CRIT "
	}

function M.add_to_whitelist(tag, state)
	M.tag_whitelist[tag] = state
end

function M.add_to_blacklist(tag, state)
	state = state or true
	M.tag_blacklist[tag] = state
end

function M.override_print()
	print = M.i
end

-- Sets the minimum log level to log, default is log.DEBUG
function M.set_level(level)
	M.logging_level = level
end

-- TRACE
function M.t(message, tag,debug_level)
	local level = M.TRACE
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.trace(message, tag,debug_level)
	local level = M.TRACE
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

-- DEBUG
function M.d(message, tag,debug_level)
	local level = M.DEBUG
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.debug(message, tag,debug_level)
	local level = M.DEBUG
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

-- INFO
function M.i(message, tag,debug_level)
	local level = M.INFO
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.info(message, tag,debug_level)
	local level = M.INFO
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

-- WARNING
function M.w(message, tag,debug_level)
	local level = M.WARNING
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.warning(message, tag,debug_level)
	local level = M.WARNING
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

-- ERROR
function M.e(message, tag,debug_level)
	local level = M.ERROR
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
	error(message)
end

function M.error(message, tag,debug_level)
	local level = M.ERROR
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
	error(message)
end

-- CRITICAL
function M.c(message, tag,debug_level)
	local level = M.CRITICAL
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.critical(message, tag,debug_level)
	local level = M.CRITICAL
	debug_level = debug_level or 1
	M.save_log_line(message, level, tag, debug_level)
end

function M.save_log_line(line, level, tag, debug_level)
	if line == nil then return end
	line = tostring(line)
	if M.logging == false then return false end

	if M.disable_logging_for_release and M.is_debug == false then return false end

	debug_level = debug_level or 0

	level = level or M.NONE
	if level < M.logging_level then return false end

	tag = tag or "none"
	if M.use_tag_whitelist then
		if M.tag_whitelist[tag] ~= true then
			return false
		end
	end

	if M.use_tag_blacklist then
		if M.tag_blacklist[tag] then
			return false
		end
	end

	local level_string = M.log_level_names[level]

	local path = M.get_logging_path()
	local log = io.open(path, "a")
	local timestamp = os.time()
	local timestamp_string = os.date('%H:%M:%S', timestamp)

	local head = "[" .. level_string .. timestamp_string .. "]"
	local body = ""

	if tag then
		head = head .. " " .. tag .. ":"
	end

	if debug then
		local info = debug.getinfo(2 + debug_level, "Sl") -- https://www.lua.org/pil/23.1.html
		local short_src = info.short_src
		local line_number = info.currentline
		body = short_src .. ":" .. line_number .. ":"
	end

	local complete_line = head .. " " .. body .. " " .. line
	if M.print == true then M.print_f(complete_line) end

	log:write(complete_line, "\n")
	io.close(log)
	if M.verbose then print("Log: log.save_log_line - Log written to " .. path) end
end

function M.set_appname(appname)
	-- if you don't want appname filtered then set it directly
	-- log.appname = "whatever"
	appname = appname:gsub('%S%W','')
	M.appname = appname
end

function M.toggle_print()
	if M.print then
		M.print = false
	else
		M.print = true
	end
end

function M.toggle_verbose()
	if M.verbose then
		M.verbose = false
	else
		M.verbose = true
	end
end

function M.toggle_logging()
	if M.logging then
		M.logging = false
	else
		M.logging = true
	end
end

local function appname_check()
	if M.appname == "DefoldLog" then
		print("Log: You need to set a custom appname with log.set_appname(appname)")
	end
end

function M.get_logging_path()
	appname_check()
	if M.use_date_for_filename then
		local timestamp = os.time()
		M.logging_filename = os.date('%Y-%m-%d', ts) .. ".log"
	end
	if M.sysinfo.system_name == "Linux" then
		-- For Linux we must modify the default path to make Linux users happy
		local appname = "config/" .. tostring(M.appname)
		return sys.get_save_file(appname, M.logging_filename)
	end
	return sys.get_save_file(M.appname, M.logging_filename)
end

function M.get_logging_dir_path()
	appname_check()
	if M.sysinfo.system_name == "Linux" then
		-- For Linux we must modify the default path to make Linux users happy
		local appname = "config/" .. tostring(M.appname)
		return sys.get_save_file(appname, "")
	end
	return sys.get_save_file(M.appname, "")
end

function M.delete_old_logs(days)
	if not lfs then print("Log: LFS is required (for now) to use log.prune_old_logs(). Check the readme!"); return false end
	if not M.use_date_for_filename then print("Log: log.use_date_for_filename must be true to use log.prune_old_logs()!"); return false end

	local days_to_log_expire = days or M.delete_old_logs_days
	local time_now = os.time()
	local max_time_difference = 86400 * days_to_log_expire
	local directory = M.get_logging_dir_path()
	for file in lfs.dir(directory) do
		if file ~= "." and file ~= ".." then
			local delete_file_ok = true
			local it = 0
			local date = ""
			local filetype = ""
			-- break filename of NNNN-NN-NN.log in half at the .
			for i in string.gmatch(file, "[^%.]+") do
				it = it + 1
				if it == 1 then
					date = i
				elseif it == 2 then
					if i == "log" then
						filetype = "log"
					end
				elseif it >= 3 then
					-- mismatch
					delete_file_ok = false
				end
			end
			if filetype == "log" then
				local xyear = 0
				local xmonth = 0
				local xday = 0
				it = 0
				-- break (hopefully) date string NNNN-NN-NN into dates by the -
				for i in string.gmatch(date, "[^%-]+") do
					it = it + 1
					if it == 1 then
						xyear = tonumber(i)
					elseif it == 2 then
						xmonth = tonumber(i)
					elseif it == 3 then
						xday = tonumber(i)
					elseif it >= 4 then
						-- mismatch
						delete_file_ok = false
					end

				end
				local timestamp = os.time({year = xyear, month = xmonth, day = xday, hour = 0, min = 0, sec = 0, isdst=false})
				if timestamp ~= nil and delete_file_ok then
					if time_now - timestamp >= max_time_difference then
						if M.verbose then print("Log: log.delete_old_logs " .. file .. " is old - deleted!") end
						os.remove(directory .. file)
					end
				end
			end
		end
	end
end

return M