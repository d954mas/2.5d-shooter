local COMMON = require "libs.common"
local SCENE_ENUMS = require "libs.sm.enums"

local SceneStack = require "libs.sm.scene_stack"
local Scene = require "libs.sm.scene"
local TAG = "SM"

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
		local ok, res = coroutine.resume(self.co, dt)
		if not ok then
			COMMON.e(res, TAG)
			self.co = nil
		end
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

function M:show(name)
	checks("?", "string")
	assert(not self:is_working())
end

function M:back() end

function M:back_to() end

function M:close_modals()

end




---@class SceneUnloadConfig
---@field new_scene Scene|nil wait scene loading if not nil
---@field skip_transition boolean|nil
---@field keep_show boolean|nil

---@param stack SceneStack
local function unload_top_f(stack)
	local scene = stack:pop()
	if not scene then return end
end

---@param scene Scene
local function load_scene_f(scene)
	checks("Scene")
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

local function unload_scene_f(scene, config)
	checks("Scene", {
		new_scene = "?Scene",
		skip_transition = "?boolean",
		keep_show = "?boolean",
	})
	config = config or {}

	COMMON.i("release input for scene:" .. scene._name, TAG)
	msg.post(scene._url, COMMON.HASHES.INPUT_RELEASE_FOCUS)

	if scene._state == SCENE_ENUMS.RUNNING then
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
local function close_modals_f(stack)
	checks("SceneStack")
	while (true) do
		local scene = stack:peek()
		if not scene or not scene._config.modal then break end
		print("unload modal scene:" .. scene._name)
		unload_scene_f(scene)
	end
	self.co = nil
end

---@param stack SceneStack
---@param scene Scene
local function show_scene_f(stack, scene)
	checks("SceneStack", "Scene")

	--start loading new scene.Before old was unloaded.
	if scene._state == SCENE_ENUMS.STATES.UNLOADED then
		scene:load(true)
	end

	---@type SceneUnloadConfig
	local unload_config = {}
	unload_config.new_scene = scene
	if (scene._config.modal) then
		local prev_modal = stack:peek() and stack:peek()._config.modal
		--show current scene when show new modal
		unload_config.keep_show = not prev_modal
	else
		close_modals_f(stack)
	end
	unload_scene_f(stack:pop(), unload_config)
	load_scene_f(scene)
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