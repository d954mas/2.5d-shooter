--BASE SCENE MODULE.
local COMMON = require "libs.common"
local LOADER = require "libs.sm.loader"
local RX = require "libs.rx"
local TAG = "SCENE"

---@class SceneConfig
---@field modal boolean

---@class Scene
---@field _input table data for scene
---@field _state number Scene state
---@field _name string unique name. Used for changing scenes
---@field _url url proxy url
---@field _controller_url url scene controller url
---@field _config SceneConfig SceneConfig
---@field _sm SceneManager
local Scene = COMMON.class('Scene')

local STATES = COMMON.read_only({
    UNLOADED = "UNLOADED",
    LOADED = "LOADED",
    HIDE = "HIDE", --scene is loaded.But not showing on screen
    PAUSED = "PAUSED", --scene is showing.But update not called.
    RUNNING = "RUNNING", --scene is running
    LOADING = "LOADING", --scene is running
})

local TRANSITIONS = COMMON.read_only({
    ON_HIDE = "ON_HIDE",
    ON_SHOW = "ON_SHOW",
    ON_BACK_SHOW = "ON_BACK_SHOW",
    ON_BACK_HIDE = "ON_BACK_HIDE",
})

local STATIC = COMMON.read_only({
    STATES = STATES,
    TRANSITIONS = TRANSITIONS
})


---@param name string of scene.Must be unique
function Scene:initialize(name,url,controller_url)
    self._name = assert(name)
    self._url = msg.url(assert(url))
    self._controller_url = msg.url(assert(controller_url))
    self._input = nil
    self.STATIC = STATIC
    self._config = {}

    self._state = self.STATIC.STATES.UNLOADED
    self._state_subject = RX.Subject.create()
    self._state_subject:onNext(self.STATIC.STATES.UNLOADED)
    self._state_subject:subscribe(function(v)
        COMMON.i(string.format("%s from:%s to:%s",self._name, self._state,v),TAG)
        self._state = v
    end)
    self._scheduler = COMMON.RX.CooperativeScheduler.create()
end


--region BASE
--used by scene manager to manipulate scene
--can be called outside of go context
--all functions called inside coroutine. So you can wait

--return observable to make preload work
---@return Observable
function Scene:load()
    assert(self._state == STATES.UNLOADED)
    self._state_subject:onNext(STATES.LOADING)
    local s = LOADER.load(self)
    s:subscribe(nil,nil,function()
        self._state_subject:onNext(STATES.LOADED)
    end)
    return s
end

function Scene:unload()
    assert(self._state == STATES.HIDE)
    self._state_subject:onNext(STATES.UNLOADED)
    LOADER.unload(self)
end

function Scene:hide()
    assert(self._state == STATES.PAUSED)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_HIDE)
    msg.post(self._url, COMMON.HASHES.MSG_DISABLE)
    self._state_subject:onNext(STATES.HIDE)
end

function Scene:show()
    assert(self._state == STATES.HIDE)
    msg.post(self._url, COMMON.HASHES.MSG_ENABLE)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_SHOW)
    self._state_subject:onNext(STATES.PAUSED)
end

function Scene:init()
    assert(self._state == STATES.LOADED)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_INIT, {scene_name = self._name})
    self._state_subject:onNext(STATES.HIDE)
end

function Scene:pause()
    assert(self._state == STATES.RUNNING)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_PAUSE)
    msg.post(self.url, "set_time_step", {factor = 0, mode = 0})
    self._state_subject:onNext(STATES.PAUSED)
end
function Scene:resume()
    assert(self._state == STATES.PAUSED)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_RESUME)
    msg.post(self.url, "set_time_step", {factor = 1, mode = 0})
    self._state_subject:onNext(STATES.RUNNING)
end

---@param transition string
function Scene:transition(transition)
    msg.post(self._controller_url, COMMON.HASHES.MSG_SM_TRANSITION,{transition = transition})

end


--endregion

--region ON
--called in go context. Use messages for it.
function Scene:on_hide()
end
function Scene:on_show()
end

function Scene:on_pause()
end
function Scene:on_resume()
end

--called in go context. Can use yeild
---@param transition number
function Scene:on_transition(transition)

end
--endregion

--region GO

--not go init. Is is scene init.
function Scene:on_init(go_self)
    self._go_self = go_self
end

function Scene:on_final()
end

function Scene:on_update(dt)
    self._scheduler:update(dt)
end

function Scene:on_message( message_id, message, sender)
end

function Scene:on_input( action_id, action)
end

function Scene:on_reload(go_self)
end
--endregion

return Scene