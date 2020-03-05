local COMMON = require "libs.common"
local BaseAction = require "libs.actions.action"


--self.childs is reverse order.Last in order will be played first
---@class SequenceAction:Action
local Action = COMMON.class("SequenceAction",BaseAction)
Action.__can_add_action_while_run = true
function Action:initialize(config)
	config = config or {}
	BaseAction.initialize(self,config)
	---@type Action[]
	self.childs = {}
	if self.config.actions then
		for i=#self.config.actions,1,-1 do
			self:add_action(self.config.actions[i],true)
		end
	end
end

function Action:add_action(action,to_end)
	assert(action)
	assert(action:isInstanceOf(BaseAction))
	assert(not self.coroutine or self.__can_add_action_while_run,"can't add to running action")
	if to_end then
		table.insert(self.childs,action)
	else
		table.insert(self.childs, 1,action)
	end
end

function Action:act(dt)
	while(self.childs[1] ~= nil or not self.drop_empty) do
		if self.childs[1] then
			local current = self.childs[#self.childs]
			current:update(dt)
			if current:is_finished() then
				table.remove(self.childs)
			end
		end
		dt = coroutine.yield()
	end
end

return Action
