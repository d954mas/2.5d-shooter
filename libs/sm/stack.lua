local CLASS = require "libs.middleclass"

---@class Stack
local M = CLASS.class("Stack")

function M:initialize()
	self.stack = {}
end

--- Pushes a value at the head of the heap
---@param value any
function M:push(value)
	assert(value, "value can't be nil")
	table.insert(self.stack, value)
end

--- Remove and return the value at the head of the heap
---@return any
function M:pop() return table.remove(self.stack) end

---Looks at the object of this stack without removing it from the stack.
---@return any
function M:peek(value)
	return self.stack[#self.stack - (value or 0)]
end

--- Clears the heap
function M:clear() self.stack = {} end

--- Checks if the heap is empty
---@return boolean
function M:is_empty()
	return #self.stack == 0
end

---@return number
function M:size() return #self.stack end

return M
