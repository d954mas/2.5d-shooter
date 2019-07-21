local ECS = require 'libs.ecs'
local COMMOM = require "libs.common"

local HASH_FLASH = hash("flash")
local TEMP_V4 = vmath.vector4()

---@class FlashSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("flash_info")

---@param e Entity
function System:process(e, dt)
	local info = e.flash_info
	if e.url_sprite then
		info.current_time = COMMOM.LUME.clamp(info.current_time + dt,0,info.total_time)
		--Ping-Pong animation
		if info.current_time <= info.total_time/2 then
			TEMP_V4.x = COMMOM.LUME.lerp( 0,1,info.current_time/info.total_time*2)
		elseif info.current_time < info.total_time then
			TEMP_V4.x = COMMOM.LUME.lerp(0,1,info.total_time/info.current_time-1)
		else
			TEMP_V4.x = 0
			e.flash_info = nil
			self.world:addEntity(e)
		end
		TEMP_V4.x = TEMP_V4.x * 0.7
		sprite.set_constant(e.url_sprite,HASH_FLASH,TEMP_V4)
	end
end



return System