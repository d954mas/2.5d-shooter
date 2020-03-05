local CLASS = require "libs.middleclass"
local COROUTINE = require "libs.coroutine"
local CONTEXT_MANAGER = require "libs_project.contexts_manager"

---@class Thread
local Thread = CLASS.class("Thread")

function Thread:initialize(fun)
	---@type thread
	self.coroutine = fun and coroutine.create(fun)
	self.drop_empty = true
	self.speed = 1
	self.script_context = nil
end

function Thread:context_use(context)
	self.script_context = context or lua_script_instance.Get()
end

function Thread:is_empty()
	return not self.coroutine and true or false
end

function Thread:is_finished()
	return self:is_empty() and self.drop_empty
end

function Thread:update_pre()
	if self.script_context then
		self.old_context_id = CONTEXT_MANAGER:set_context_top_by_instance(self.script_context)
	end
end

function Thread:update(dt)
	self:update_pre()
	dt = dt * self.speed
	self:on_update(dt)
	self:update_post()
end

function Thread:update_post()
	if self.old_context_id then
		CONTEXT_MANAGER:remove_context_top(self.old_context_id)
		self.old_context_id = nil
	end
end

function Thread:on_update(dt)
	if self.coroutine then
		self.coroutine = COROUTINE.coroutine_resume(self.coroutine, dt)
	end
end

return Thread