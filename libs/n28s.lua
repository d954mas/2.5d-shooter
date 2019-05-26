local CLASS = require "libs.middleclass"
local M = {}
local DEFOLD_METHODS = {'init', 'final', 'update', 'on_input', 'on_reload',"on_message"}

local Registrator = CLASS.class("N28SRegistrator")
local Script = CLASS.class("N28SScript")
---@field go_self table

function Registrator:initialize()
	self.__register = false
	self.scripts = {}
	for _,m in ipairs(DEFOLD_METHODS) do
		self["methods_".. m] = {}
	end
end

function Registrator:add_script(script)
	assert(not self.__register)
	assert(script,"script can't be nil")
	assert(script.isSubclassOf,"add class not instance")
	assert(script:isSubclassOf(Script),"can add only script classes")
	table.insert(self.scripts,script)
	for _,m in ipairs(DEFOLD_METHODS) do
		if script[m] then
			table.insert(self["methods_".. m],script)
		end
	end
end

function Registrator:register()
	assert(not self.__register)
	self.__register = true
	for i = 1, #DEFOLD_METHODS do
		local m = DEFOLD_METHODS[i]
		if m == "init" then
			local prev = _G[m]
			_G[m] = function(go_self, ...)
				if prev then prev(go_self,...) end
				self:go_init(go_self)
				if go_self["__scripts_" .. m] then
					for _, script in ipairs(go_self["__scripts_" .. m]) do
						script[m](script,...)
					end
				end
			end
		elseif #self["methods_".. m] > 0 then
			local prev = _G[m]
			_G[m] = function(go_self, ...)
				if prev then prev(go_self,...) end
				if go_self["__scripts_" .. m] then
					for _, script in ipairs(go_self["__scripts_" .. m]) do
						script[m](script,...)
					end
				end
			end
		end
	end
end

function Registrator:go_init(go_self)
	for _,script in ipairs(self.scripts) do
		local script_instance = script(go_self)
		for _,m in ipairs(DEFOLD_METHODS) do
			if script_instance[m] then
				local key = "__scripts_" .. m
				go_self[key] = go_self[key] or {}
				table.insert(go_self[key],script_instance)
			end
		end
	end
end


function Script:initialize(go_self)
	self.go_self = go_self
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