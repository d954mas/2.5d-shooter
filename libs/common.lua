local EVENT_BUS = require "libs.event_bus"

local M = {}
M.HASHES = require "libs.hashes"
M.MSG = require "libs.msg_receiver"
M.CLASS = require "libs.middleclass"
M.LUME = require "libs.lume"
M.RX = require "libs.rx"
M.EVENTS = require "libs.events"
M.CONSTANTS = require "libs.constants"
M.EVENT_BUS =EVENT_BUS() --global event_bus
M.GLOBAL = {}
M.N28S = require "libs.n28s"
---@type Render set inside render. Used to get buffers outside from render
M.RENDER = nil
---@type Localization
M.LOCALE = nil


--region input
M.INPUT = require "libs.input_receiver"
function M.input_acquire(url)
	M.INPUT.acquire(url)
end

function M.input_release(url)
	M.INPUT.release(url)
end
--endregion

--region log
M.LOG = require "libs.log"

function M.init_log()
	M.LOG.set_appname("game")
	M.LOG.toggle_print()
	M.LOG.override_print()
	M.LOG.add_to_blacklist("Sound")
	M.LOG.add_to_blacklist("States")
	M.LOG.use_tag_blacklist = true
end
M.init_log()

function M.t(message, tag)
	M.LOG.t(message, tag,2)
end

function M.trace(message, tag)
	M.LOG.trace(message,tag,2)
end

function M.d(message, tag)
	M.LOG.d(message,tag,2)
end

function M.debug(message, tag)
	M.LOG.debug(message,tag,2)
end

function M.i(message, tag)
	M.LOG.i(message,tag,2)
end

function M.info(message, tag)
	M.LOG.info(message,tag,2)
end

-- WARNING
function M.w(message, tag)
	M.LOG.w(message,tag,2)
end

function M.warning(message, tag)
	M.LOG.warning(message,tag,2)
end

-- ERROR
function M.e(message, tag)
	M.LOG.e(message,tag,2)
end

function M.error(message, tag)
	M.LOG.error(message,tag,2)
end

-- CRITICAL
function M.c(message, tag)
	M.LOG.c(message,tag,2)
end

function M.critical(message, tag)
	M.LOG.critical(message,tag,2)
end
--endregion

function M.weakref(t)
	local weak = setmetatable({content=assert(t)}, {__mode="v"})
	return function() return weak.content end
end

--region READ_ONLY
local function len(self)
	return #self.__VALUE
end

--TODO CHECK PERFORMANCE OF OVERRIDE FN
--http://lua-users.org/wiki/GeneralizedPairsAndIpairs
local rawnext = next
function next(t,k)
	local m = getmetatable(t)
	local n = m and m.__next or rawnext
	return n(t,k)
end

function pairs(t) return next, t, nil end

local function _ipairs(t, var)
	var = var + 1
	local value = t[var]
	if value == nil then return end
	return var, value
end
function ipairs(t) return _ipairs, t, 0 end

-- remember mappings from original table to proxy table
local proxies = setmetatable( {}, { __mode = "k" } )

--__VALUE use to work with debugger or pprint
---@generic T
---@param t T
---@return T
function M.read_only(t)
	if type(t) == "table" then
		-- check whether we already have a readonly proxy for this table
		local p = proxies[t]
		if not p then
			-- create new proxy table for t
			p = setmetatable( {__VALUE = t,__len = len}, {
				__next = function(_, k) return next(t, k) end,
				__index = function(_, k) return t[k] end,
				__newindex = function() error( "table is readonly", 2 ) end,
			} )
			proxies[t] = p
		end
		return p
	else
		return t
	end
end


---@generic T
---@param t T
---@return T
function M.read_only_recursive( t )
	if type(t) == "table" then
		-- check whether we already have a readonly proxy for this table
		local p = proxies[t]
		if not p then
			-- create new proxy table for t
			p = setmetatable( {__VALUE = t,__len = len}, {
				--errors in debugger if k is read_only_recursive
				__next = function(_, k)
					local key,v = next(t, k)
					return key, M.read_only_recursive(v)
				end,
				__index = function(_, k) return M.read_only_recursive( t[ k ] ) end,
				__newindex = function() error( "table is readonly", 2 ) end,
			} )
			proxies[t] = p
		end
		return p
	else
		-- non-tables are returned as is
		return t
	end
end
--endregion
--region class
function M.class(name, super)
	return M.CLASS.class(name, super)
end

function M.new_n28s()
	return M.CLASS.class("NewN28S",M.N28S.Script)
end
--endregion

---@return coroutine|nil return coroutine if it can be resumed(no errors and not dead)
function M.coroutine_resume(cor,...)
	local ok, res = coroutine.resume(cor,...)
	if not ok then
		M.e(res, "COROUTINE")
	else
		return not (coroutine.status(cor) == "dead") and cor
	end
end

function M.coroutine_wait(time)
	assert(time)
	local dt = 0
	while dt<time do
		dt = dt + coroutine.yield()
	end
end

--generate empty table for native extension.
--use it on system that not supported
function M.empty_ne(name,ignore_log)
	if not _G[name] then
		local t = {}
		local mt = {}
		local f = function() end
		function mt.__index(_, k)
			if not ignore_log then
				M.w("NE","index empty ne:" .. k)
			end
			return f
		end
		function mt.__newindex(_,k,_)
			if not ignore_log then
				M.w("NE","newindex empty ne:" .. k)
			end
			return
		end
		setmetatable(t, mt)
		_G[name] = t
	end
end

return M