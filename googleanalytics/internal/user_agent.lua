--- Utility module to create a reasonably well formatted user agent string based
-- on the platform dmengine is running on.

local M = {}

--- Get a user agent string
-- @return User agent string
function M.get()
	local sys_info = sys.get_sys_info()
	local device_model = sys_info.device_model
	local manufacturer = sys_info.manufacturer
	local system_name = sys_info.system_name
	local system_version = sys_info.system_version
	local system_version_underscore = system_version:gsub("%.", "_")
	local api_version = sys_info.api_version
	local device_language = sys_info.device_language

	local engine_info = sys.get_engine_info()
	local engine_version = engine_info.version

	local user_agent
	if sys_info.system_name == "Android" then
		user_agent = ("Mozilla/5.0 (Linux; Android %s; %s %s) AppleWebKit/537.36 (KHTML, like Gecko) Defold/%s"):format(system_version, manufacturer, device_model, engine_version)
	elseif sys_info.system_name == "iPhone OS" then
		if sys_info.device_model:match("iPad.*") == sys_info.device_model then
			user_agent = ("Mozilla/5.0 (iPad; CPU OS %s like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Defold/%s"):format(system_version_underscore, engine_version)
		elseif sys_info.device_model:match("iPod.*") == sys_info.device_model then
			user_agent = ("Mozilla/5.0 (iPod; CPU OS %s like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Defold/%s"):format(system_version_underscore, engine_version)
		else
			user_agent = ("Mozilla/5.0 (iPhone; CPU iPhone OS %s like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Defold/%s"):format(system_version_underscore, engine_version)
		end
	elseif sys_info.system_name == "Darwin" then
		user_agent = ("Mozilla/5.0 (Macintosh; Intel Mac OS X %s) AppleWebKit/602.3.12 (KHTML, like Gecko) Defold/%s"):format(system_version, engine_version)
	elseif sys_info.system_name == "Windows" then
		user_agent = ("Mozilla/5.0 (MSIE 10.0; Windows NT %s; Trident/5.0) Defold/%s"):format(system_version, engine_version)
	elseif sys_info.system_name == "Linux" then
		user_agent = ("Mozilla/5.0 (X11; Linux x86_64; Debian) AppleWebKit/537.36 (KHTML, like Gecko) Defold/%s"):format(engine_version)
	elseif sys_info.system_name == "HTML5" then
		-- modern browsers do not allow that the user agent is set manually
		user_agent = nil
	else
		user_agent = ("Mozilla/5.0 (%s; %s; %s %s) Defold/%s"):format(system_name, system_version, device_model, manufacturer, engine_version)
	end
	return user_agent
end


return M