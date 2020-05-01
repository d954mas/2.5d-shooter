local ECS = require 'libs.ecs'

---@class AnimationWallSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("wall", "wall_animation")
System.name = "AnimationWallSystem"

---@param e Entity
function System:process(e, dt)
	e.wall_animation:update(dt)
	local frame = e.wall_animation:get_frame()
	if(e.wall_go and frame ~= e.wall_animation_current_animation) then
		sprite.play_flipbook(e.wall_go.base.west,frame)
		sprite.play_flipbook(e.wall_go.base.east,frame)
		sprite.play_flipbook(e.wall_go.base.north,frame)
		sprite.play_flipbook(e.wall_go.base.south,frame)
		if(e.wall_go.transparent) then
			sprite.play_flipbook(e.wall_go.transparent.west,frame)
			sprite.play_flipbook(e.wall_go.transparent.east,frame)
			sprite.play_flipbook(e.wall_go.transparent.north,frame)
			sprite.play_flipbook(e.wall_go.transparent.south,frame)
		end
		e.wall_animation_current_animation = frame
	else
		e.wall_animation_current_animation = nil
	end


end

return System