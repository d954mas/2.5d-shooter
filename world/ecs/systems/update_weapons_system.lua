local ECS = require 'libs.ecs'
---@class UpdateWeaponsSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("weapons","weapon_current_idx")

---@param e Entity
function System:process(e, dt)
	e.weapons[e.weapon_current_idx]:update(dt)
end


return System