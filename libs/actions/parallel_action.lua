local COMMON = require "libs.common"
local SequenceAction = require "libs.actions.sequence_action"

---@class ParallelAction:SequenceAction
local Action = COMMON.class("ParallelAction", SequenceAction)

Action.__can_add_action_while_run = true

function Action:act(dt)
	local current
	while (self.childs[1] ~= nil or not self.drop_empty) do
		for i = #self.childs, 1, -1 do
			current = self.childs[i]
			current:update(dt)
			if current:is_finished() then
				table.remove(self.childs)
			end
		end
		dt = coroutine.yield()
	end
end

return Action