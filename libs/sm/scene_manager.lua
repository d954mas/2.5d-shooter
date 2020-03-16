local COMMON = require "libs.common"
local SCENE_ENUMS = require "libs.sm.enums"

local SceneStack = require "libs.sm.scene_stack"
local Scene = require "libs.sm.scene"

---@class SceneManager2
local M = COMMON.class("SceneManager")

function M:initialize()
	self.stack = SceneStack()
	---@type Scene[]
	self.scenes = {}
	self.co = nil
end

---@param scenes Scene[]
function M:register(scenes)
	assert(#self.scenes == 0, "register_scenes can be called only once")
	assert(scenes, "scenes can't be nil")
	assert(#scenes ~= 0, "scenes should have one or more scene")
	for _, scene in ipairs(scenes) do
		assert(scene:isInstanceOf(Scene))
		assert(not scene.__declaredMethods, "register instance not class(add ())")
		assert(scene._name, "scene name can't be nil")
		assert(not self.scenes[scene._name], "scene:" .. scene._name .. " already exist")
		self.scenes[scene._name] = scene
	end
end

function M:is_working() return self.co end

function M:update(dt)
	if self.co then
		self.co = COMMON.coroutine_resume(self.co)
	end

	local scenes_updated = {}
	for i = #self.stack, 1, -1 do
		---@type Scene
		local scene = self.stack[i]
		--can have multiple instance of same scene in stack
		if (scene._state == SCENE_ENUMS.STATES.RUNNING and not scenes_updated[scene]) then
			scene:update(dt)
			scenes_updated[scene] = true
		end
	end
end

function M:on_input(action_id, action)
	local top = self:get_top()
	if (top) then
		return top:on_input(action_id, action)
	end
end

function M:reload() end

---@param input nil|table
function M:show(name, input)
	checks("?", "string", "?")
	assert(not self:is_working())
	self.co = coroutine.create(function()
		self:_show_scene_f(self:get_scene_by_name(name), input)
	end)
end

function M:replace(name)
	checks("?", "string")
	assert(not self:is_working())
	self.co = coroutine.create(function()
		self:_replace_scene_f(self:get_scene_by_name(name))
	end)
end

function M:back()
	assert(not self:is_working())
	self.co = coroutine.create(function()
		self:_back_scene_f()
	end)
end

function M:back_to() end

function M:close_modals()

end




---@class SceneUnloadConfig
---@field new_scene Scene|nil wait scene loading if not nil
---@field skip_transition boolean|nil
---@field keep_show boolean|nil

---@param scene Scene
function M:_load_scene_f(scene)
	checks("?", "Scene")
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then
		scene:load()
	end
	--wait next scene loaded
	while scene._state == SCENE_ENUMS.STATES.LOADING do coroutine.yield() end
	if scene._state == SCENE_ENUMS.STATES.HIDE then
		scene:show()
	end

	if scene._state == SCENE_ENUMS.STATES.PAUSED then
		scene:resume()
		--scene_transition(self, new_scene, new_scene.STATIC.TRANSITIONS.ON_SHOW)
	end
end

---@param config SceneUnloadConfig
function M:_unload_scene_f(scene, config)
	checks("?", "Scene", {
		new_scene = "?Scene",
		skip_transition = "?boolean",
		keep_show = "?boolean",
	})
	config = config or {}

	if scene._state == SCENE_ENUMS.STATES.RUNNING then
		--if !config.skip_transition then scene_transition(self,scene,scene.STATIC.TRANSITIONS.ON_HIDE) end
		scene:pause()
	end

	--wait new scene to load.If not wait, user will see empty screen
	if (config.new_scene) then
		while config.new_scene._state == SCENE_ENUMS.STATES.LOADING do coroutine.yield() end
	end

	if scene._state == SCENE_ENUMS.STATES.PAUSED and not config.keep_show then
		scene:hide()
	end
	if scene._state == SCENE_ENUMS.STATES.HIDE and not scene._config.keep_loaded then
		scene:unload()
	end
end

---@param stack SceneStack
function M:_close_modals_f()
	while (true) do
		local scene = self.stack:peek()
		if not scene or not scene._config.modal then break end
		print("unload modal scene:" .. scene._name)
		self:_unload_scene_f(self.stack:pop())
	end
	self.co = nil
end

---@param scene Scene
function M:_show_scene_f(scene, input)
	checks("?", "Scene", "?")

	local current_scene = self.stack:peek()

	--start loading new scene.Before old was unloaded.
	scene._input = input
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then scene:load(true) end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = scene
	if (scene._config.modal) then
		assert(current_scene, "modal can't be first scene")
		local current_modal = current_scene._config.modal
		--show current scene when show new modal
		unload_config.keep_show = not current_modal
	else
		self:_close_modals_f()
	end
	if (current_scene) then self:_unload_scene_f(current_scene, unload_config) end
	self:_load_scene_f(scene)
	self.stack:push(scene)
end

---@param scene Scene
function M:_replace_scene_f(scene, input)
	checks("?", "Scene", "?")

	local current_scene = self.stack:peek()
	assert(current_scene, "can't replace. No current scene")
	--start loading new scene.Before old was unloaded.
	scene._input = input
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then scene:load(true) end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = scene

	assert(scene._config.modal ~= current_scene._config.modal, "modal can't replace scene and vice versa")

	self:_unload_scene_f(self.stack:pop(), unload_config)
	self:_load_scene_f(scene)
	self.stack:push(scene)
end

function M:_back_scene_f()
	assert(#self.stack.stack > 1, "can't go back.")
	local current_scene = self.stack:peek()
	local prev_scene = self.stack:peek(1)

	--start loading new scene.Before old was unloaded.
	if prev_scene._state == SCENE_ENUMS.STATES.UNLOADED then prev_scene:load(true) end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = prev_scene

	if (current_scene) then self:_unload_scene_f(self.stack:pop(), unload_config) end
	self:_load_scene_f(prev_scene)
end

---@return Scene
function M:get_top()
	return self.stack:peek()
end

function M:get_scene_by_name(name)
	checks("?", "string")
	local scene = self.scenes[name]
	return assert(scene, "unknown scene:" .. name)
end

return M