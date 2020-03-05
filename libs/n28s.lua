local CLASS = require "libs.middleclass"
local M = {}
--no init. It called when script added to go
local DEFOLD_METHODS = { 'final', 'update', 'on_input', 'on_reload', "on_message" }

---@class N28SRegistrator
local Registrator = CLASS.class("N28SRegistrator")

---@class N28SScript
local Script = CLASS.class("N28SScript")
---@field go_self table

function Registrator:initialize()
	self.__register = false
	self.scripts = {}
	---@type N28SScript[]
	self.methods = {}
	for _, m in ipairs(DEFOLD_METHODS) do
		self.methods[m] = {}
	end
end

function Registrator:add_script(script)
	assert(not self.__register)
	assert(script, "script can't be nil")
	assert(script.isInstanceOf, "add instance not class")
	assert(script:isInstanceOf(Script), "can add only script classes")
	table.insert(self.scripts, script)
	for _, m in ipairs(DEFOLD_METHODS) do
		if script[m] then
			table.insert(self.methods[m], script)
		end
	end
end

function Registrator:register()
	assert(not self.__register)
	assert(not _G.init, "already register")
	self.__register = true
	_G.init = function(go_self, ...)
		self:go_init(go_self)
		for _, script in ipairs(self.scripts) do
			script:_set_go(go_self)
		end
	end

	for i = 1, #DEFOLD_METHODS do
		local m = DEFOLD_METHODS[i]
		if #self.methods[m] > 0 then
			assert(not _G[m], "already register " .. m)
			_G[m] = function(go_self, ...)
				for _, script in ipairs(go_self._script_methods[m]) do
					script[m](script, ...)
				end
			end
		end
	end
end

--create all arrays
function Registrator:go_init(go_self)
	go_self._script_methods = go_self._script_methods or {}
	for _, script in ipairs(self.scripts) do
		for _, m in ipairs(DEFOLD_METHODS) do
			if script[m] then
				go_self._script_methods[m] = go_self._script_methods[m] or {}
			end
		end
	end
end

function Script:initialize()
end

function Script:_set_go(go)
	assert(not self._go)
	self._go = assert(go)
	self:__register()
	self:init()
end

--go should have registered global function
function Script:__register()
	assert(self._go)
	assert(not self.__registered)
	self.__registered = true
	for _, m in ipairs(DEFOLD_METHODS) do
		if self[m] then
			table.insert(self._go._script_methods[m], self)
		end
	end
end

function Script:init()

end

function M.register(script)
	local registrator = Registrator()
	registrator:add_script(assert(script))
	registrator:register()
end

M.Registrator = Registrator
M.Script = Script

--make register function of n28s(not inherits it)

return M