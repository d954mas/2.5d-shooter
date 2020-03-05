local COMMON = require "libs.common"
local BaseAction = require "libs.actions.action"
local TWEEN = require "libs.tween"

---@class TweenAction:Action
---tween worked only with tables. So convert v3,v4,quaternion to table
local Action = COMMON.class("TweenAction", BaseAction)
Action.__use_current_context = true

function Action:initialize(config)
	BaseAction.initialize(self, config)
	assert(not (config.by and config.to), "can't have by and to.Need only one of them")
	assert(not (config.by and config.to), "can't have by and to.Need only one of them")
	assert(not (config.v3 and config.v4), "can't have v3 and v4.Need only one of them")
	assert(not (config.v3 and config.quaternion), "can't have v3 and quaternion.Need only one of them")
	assert(not (config.v4 and config.quaternion), "can't have v4 and quaternion.Need only one of them")
	self.v3 = config.v3
	self.v4 = config.v4
	self.quaternion = config.quaternion

	self.config.from = self.config.from and self:config_value_to_table(self.config.from) or self:config_get_from()
	assert(type(self.config.from) == "table", "from must be table was:" .. type(self.config.from))
	self.config.to = self.config.to and self:config_value_to_table(self.config.to) or self:config_get_to()
	assert(type(self.config.to) == "table", "to must be table was:" .. type(self.config.to))

	for k, v in pairs(self.config.to) do
		assert(self.config.from[k], "no from value for key:" .. tostring(k))
	end

	self.tween_value = COMMON.LUME.clone_deep(self.config.from)
	self.tween = TWEEN.new(self.config.time, self.tween_value, self.config.to, self.config.easing)
	self.tween.initial = self.from
end

function Action:config_check(config)
	checks("?", {
		delay = "?number",
		to = "?",
		from = "?",
		by = "?",
		object = "table|userdata|string",
		property = "string",
		time = "number"
	})
end

function Action:config_value_to_table(data)
	assert(data)
	local type_data = type(data)
	if type_data == "number" then
		return { data }
	elseif type_data == "table" then
		return data
	elseif type_data == "userdata" then
		if self.v3 then
			self.v3 = vmath.vector3(data)
			return { x = data.x, y = data.y, z = data.z }
		elseif self.v4 then
			self.v4 = vmath.vector4(data)
			return { x = data.x, y = data.y, z = data.z, w = data.w }
		elseif self.quaternion then
			self.quaternion = vmath.quat(data)
			return { x = data.x, y = data.y, z = data.z, w = data.w }
		end
		error("unknown userdata")
	end
	error("unknown type:" .. type_data)
end

function Action:config_get_from()
	assert("need impl")
end

function Action:config_get_to()
	if self.config.by then
		local to = self:config_value_to_table(self.config.by)
		for k, v in pairs(to) do
			to[k] = v + self.config.from[k]
		end
	end
end

function Action:act(dt)
	if self.config.delay then
		COMMON.coroutine_wait(self.config.delay)
	end

	self.config.from = self.config.from and self:config_value_to_table(self.config.from) or self:config_get_from()

	self.tween_working = true
	while (self.tween_working) do
		self.tween_working = not self.tween:update(dt)
		self:set_property()
		dt = coroutine.yield()
	end
end

function Action:config_table_to_value(data)
	if self.v3 then
		self.v3.x = data.x
		self.v3.y = data.y
		self.v3.z = data.z
		return self.v3
	elseif self.v4 then
		self.v4.x = data.x
		self.v4.y = data.y
		self.v4.z = data.z
		self.v4.w = data.w
		return self.v4
	elseif self.quaternion then
		self.quaternion.x = data.x
		self.quaternion.y = data.y
		self.quaternion.z = data.z
		self.quaternion.w = data.w
		return self.quaternion
	end

	if data[self.config.property] then
		return data[self.config.property]
	end

	if data[1] then
		return data[1]
	end
	error("can't convert data to value")

end





--region set_value
function Action:set_property()
	assert("need impl")
end

function Action:set_property_table()
	self.config.object[self.config.property] = self:config_table_to_value(self.tween_value)
end
function Action:set_property_go()
	return go.set(self.config.object, self.config.property, self:config_table_to_value(self.tween_value))
end
function Action:set_property_gui()
	local name = "set_" .. self.config.property
	local f = gui[name]
	assert(f, "can't set property in gui:" .. name)
	if f then
		return f(self.config.object, self:config_table_to_value(self.tween_value))
	end
end

return Action