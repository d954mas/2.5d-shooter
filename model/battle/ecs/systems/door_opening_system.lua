local ECS = require 'libs.ecs'
local FACTORIES = require "model.battle.factories.factories"

---@class DoorOpeningSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("door")
System.name = "DoorOpeningSystem"

---@param e Entity
function System:process(e, dt)
	if (e.door_data.opening) then
		e.position.z = e.position.z + 1 * dt
		if(e.position.z > 1.25)then
			e.wall_cell.native_cell:set_blocked(false)
		end
		if (e.position.z > 2) then
			e.door_data.opening = false
			e.door_data.opened = true
			e.wall_cell.native_cell:set_blocked(false)
		end
	end


end

return System