local ECS = require 'libs.ecs'

---@class LookAtPlayerSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("url_sprite","look_at_player")

---@param e Entity
function System:process(e, dt)
	go.set_rotation(vmath.quat_rotation_y(self.world.world.level.player.angle.x),e.url_sprite)
end

return System