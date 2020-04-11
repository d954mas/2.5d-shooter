local COMMON = require "libs.common"

local HASH_SHADER_LIGHTS = hash("shader_lights")

local ShaderLights = COMMON.class("ShaderLights")

---@class ShaderLightsConfig
local ShaderLightsConfig = {
	size = "number",
	pixel_per_cell = "number"
}

---@param config ShaderLightsConfig
function ShaderLights:initialize(config)
	checks("?", ShaderLightsConfig)
	self.config = config
	self.buffer = buffer.create(self.config.size * self.config.size*self.config.pixel_per_cell, { { name = HASH_SHADER_LIGHTS, type = buffer.VALUE_TYPE_UINT8, count = 3 } })
	---@type World
	self.world = nil
end


function ShaderLights:final()
	self.buffer = nil
end

return ShaderLights