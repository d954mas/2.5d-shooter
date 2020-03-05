local CLASS = require "libs.middleclass"
local LUME = require "libs.lume"
local LOG = require "libs.log"
local Thread = require "libs.thread"


local TAG = "ThreadManager"
---@class ThreadManager:Thread
local ThreadManager = CLASS.class("ThreadManager",Thread)

function ThreadManager:initialize()
	Thread.initialize(self)
	---@type Thread[]
	self.childs = {}
end

---@return Thread
function ThreadManager:add(data)
	local thread
	if type(data) == "function" then thread = Thread(data)
	elseif type(data) == "table" and data.isInstanceOf and data:isInstanceOf(Thread) then
		thread = data
	end
	assert(thread,"unknown thread type for data:" .. tostring(data))
	table.insert(self.childs,1,thread)
	return thread
end
function ThreadManager:remove(thread)
	error("impl me=)")
	local idx = LUME.findi(self.childs,thread)
	if idx then
		table.remove(self.childs,idx)
	else
		LOG.warning("Can't remove.No such thread",TAG)
	end
end

function ThreadManager:is_empty()
	return #self.childs == 0
end

function ThreadManager:on_update(dt)
	for i=#self.childs,1,-1 do
		local child = self.childs[i]
		child:update(dt)
		if child:is_finished() then
			table.remove(self.childs,i)
		end
	end
end


return ThreadManager