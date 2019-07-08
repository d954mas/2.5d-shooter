local COMMON = require "libs.common"
local RX = require "libs.rx"
local TAG = "SceneLoader"
local M = {}

---@type Subject[]
M.scene_load = {} --current loading

M.scene_loaded = {} -- all loading proxy

---@param scene Scene
---@return Observable
function M.load(scene)
    assert(not M.scene_load[tostring(scene._url.path)], " scene is loading now:" .. scene._name)
    local s = RX.Subject()
    if M.is_loaded(scene) then
        COMMON.w("scene:" .. scene._name .. " already loaded")
        s:onCompleted()
        return
    end
    M.scene_load[tostring(scene._url.path)] = s
    msg.post("main:/scene_loader", COMMON.HASHES.MSG_SM_LOAD, { url = scene._url})
    return s
end

function M.is_loaded(scene)
    return M.scene_loaded[tostring(scene._url.path)]
end

function M.load_done(url)
    local subject = M.scene_load[tostring(url.path)]
    if subject then
        M.scene_load[tostring(url.path)] = nil
        M.scene_loaded[tostring(url.path)] = true
        subject:onCompleted()
    else
        COMMON.w("scene:" .. tostring(url.path) .. " not wait for loading",TAG)
    end
end

function M.unload(scene)
    msg.post(scene._url, COMMON.HASHES.MSG_UNLOAD)
    M.scene_load[tostring(scene._url.path)] = false
    M.scene_loaded[tostring(scene._url.path)] = false
end

return M