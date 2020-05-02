local ECS = require 'libs.ecs'

---@class ActionOpenDoorActionSystem:ECSSystem
local System = ECS.system()
System.name = "ActionOpenDoorActionSystem"

---@param e Entity
function System:update(dt)
	local game = self.world.game
	local result = game:raycast(game.player, 1, physics3d.GROUPS.OBSTACLE)
	local object = result[1]
	if(object) then
		local e = object.body:get_user_data()
		if(e.door) then
			pprint("door")
		end
	end
end

return System