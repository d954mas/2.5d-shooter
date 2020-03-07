local COMMON = require "libs.common"
local SCENE_ENUMS = require "libs.sm.enums"
local SCENE_LOADER = require "libs.sm.scene_loader"
local TAG = "SCENE"

---@class SceneConfig
---@field modal boolean
---@field keep_loaded boolean
local SCENE_CONFIG_DEFAULT = {
	modal = false,
	keep_loaded = false
}

--scene is singleton
--scene does not have script instance.It worked in main instance(init_controller.script)
---@class Scene
local Scene = COMMON.class('Scene')

---@param name string of scene.Must be unique
function Scene:initialize(name, url, config)
	checks("?", "string", "string|url", {
		modal = "?boolean",
		keep_loading = "?boolean"
	})
	self._name = name
	self._url = msg.url(url)
	---@type SceneConfig
	self._config = config or COMMON.LUME.clone_deep(SCENE_CONFIG_DEFAULT)
	self._state = SCENE_ENUMS.STATES.UNLOADED
end

function Scene:load(async)
	assert(self._state == SCENE_ENUMS.STATES.UNLOADED, "can't load scene in state:" .. self._state)
	self._state = SCENE_ENUMS.STATES.LOADING
	local time = os.clock()
	SCENE_LOADER.load(self):subscribe(nil, nil, function()
		self:load_done()
		self._state = SCENE_ENUMS.STATES.HIDE

		COMMON.i(string.format("%s loaded", self._name), TAG)
		COMMON.i(string.format("%s load time %s", self._name, os.clock() - time), TAG)
	end)
	while (not async and self._state == SCENE_ENUMS.STATES.LOADING) do coroutine.yield() end
end

function Scene:load_done() end

function Scene:unload()
	assert(self._state == SCENE_ENUMS.STATES.STATES.HIDE)
	SCENE_LOADER.unload(self)
	self:unload_done()
	self._state = SCENE_ENUMS.STATES.UNLOADED
	COMMON.i(string.format("%s unloaded", self._name), TAG)
end

function Scene:unload_done() end

function Scene:hide()
	assert(self._state == SCENE_ENUMS.STATES.PAUSED)
	msg.post(self._url, COMMON.HASHES.MSG.DISABLE)
	self:hide_done()
	self._state = SCENE_ENUMS.STATES.HIDE
	COMMON.i(string.format("%s hide", self._name), TAG)
end

function Scene:hide_done() end

function Scene:show()
	assert(self._state == SCENE_ENUMS.STATES.HIDE)
	msg.post(self._url, COMMON.HASHES.MSG.ENABLE)
	coroutine.yield()--wait before engine enable proxy
	self:show_done()
	self._state = SCENE_ENUMS.STATES.PAUSED
	COMMON.i(string.format("%s show", self._name), TAG)
end

function Scene:show_done() end

function Scene:pause()
	msg.post(self._url, COMMON.HASHES.INPUT.RELEASE_FOCUS)
	assert(self._state == SCENE_ENUMS.STATES.RUNNING)
	msg.post(self._url, COMMON.HASHES.MSG.SET_TIME_STEP, { factor = 0, mode = 0 })
	self:pause_done()
	self._state = SCENE_ENUMS.STATES.PAUSED
	COMMON.i(string.format("%s paused", self._name), TAG)
end

function Scene:pause_done() end

function Scene:resume()
	msg.post(self._url, COMMON.HASHES.INPUT.ACQUIRE_FOCUS)
	assert(self._state == SCENE_ENUMS.STATES.PAUSED)
	msg.post(self._url, COMMON.HASHES.MSG.SET_TIME_STEP, { factor = COMMON.GLOBAL.speed_game, mode = 0 })
	self:resume_done()
	self._state = SCENE_ENUMS.STATES.RUNNING
	COMMON.i(string.format("%s resumed", self._name), TAG)
end

function Scene:resume_done()

end

---@param transition string
function Scene:transition(transition)
	checks("?", "string")
end

--only top scene get input
function Scene:on_input(action_id, action)
end

function Scene:update(dt)
	checks("?", "number")
	assert(self._state == SCENE_ENUMS.STATES.RUNNING)
end

return Scene