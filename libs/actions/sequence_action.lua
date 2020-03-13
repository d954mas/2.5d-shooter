local COMMON = require "libs.common"
local BaseAction = require "libs.actions.action"
local table_remove = table.remove
local table_insert = table.insert

--self.childs is reverse order.Last in order will be played first
---@class SequenceAction:Action
local Action = COMMON.class("SequenceAction", BaseAction)
Action.__can_add_action_while_run = true
function Action:initialize(config)
	config = config or {}
	BaseAction.initialize(self, config)
	---@type Action[]
	self.childs = {}
	---@type Action
	self.current = nil
	if self.config.actions then
		for i = #self.config.actions, 1, -1 do
			self:add_action(self.config.actions[i], true)
		end
	end
end

function Action:add_action(action, to_end)
	assert(action)
	assert(action:isInstanceOf(BaseAction))
	assert(not self.coroutine or self.__can_add_action_while_run, "can't add to running action")
	if to_end then
		table_insert(self.childs, action)
	else
		table_insert(self.childs, 1, action)
	end
end
--If actions do not now params before it should start. For example it need tween form current tween to new value. But current value can't be calculated when action created,
--because it can be changed after action creation but before it started
function Action:add_create_action_function(fun, to_end)
	assert(fun)
	assert(type(fun) == "function")
	assert(not self.coroutine or self.__can_add_action_while_run, "can't add to running action")
	if to_end then
		table_insert(self.childs, fun)
	else
		table_insert(self.childs, 1, fun)
	end
end

function Action:act(dt)
	while (not self.drop_empty or self.current or self.childs[1] ~= nil) do
		if (not self.current) then
			self.current = table_remove(self.childs)
			if (type(self.current) == "function") then
				self.current = assert(self.current())
			end
		end
		if self.current then
			self.current:update(dt)
			if self.current:is_finished() then
				self.current = nil
			end
		end
		dt = coroutine.yield()
	end
end

return Action
