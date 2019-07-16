local M = {}

--ecs systems created in require.
--so do not cache then
local require_old = require
local require = function(k)
	local m = require_old(k)
	package.loaded[k] = nil
	return m
end

function M.load()
	M.CameraSystem = require "world.ecs.systems.update_camera_system"
	M.InputSystem = require "world.ecs.systems.input_system"
	M.MovementSystem = require "world.ecs.systems.movement_system"
	M.UpdateGoSystem = require "world.ecs.systems.update_go_system"
	M.PhysicsObstaclesSystem = require "world.ecs.systems.physics_obstacles_system"
	M.PhysicsResetCorrectionsSystem = require "world.ecs.systems.physics_reset_corrections_system"
	M.RotationLookAtPlayerSystem = require "world.ecs.systems.rotation_look_at_player_system"
	M.RotationGlobalSystem = require "world.ecs.systems.rotation_global_system"
	M.DamageSystem = require "world.ecs.systems.damage_system"
	M.CollisionDamageRotateSystem = require "world.ecs.systems.collision_damage_rotate_system"

	M.DrawObjectsSystem = require "world.ecs.systems.draw_objects_system"
	M.DrawWallsSystem = require "world.ecs.systems.draw_walls_system"
	M.UpdateObjectColorSystem = require "world.ecs.systems.update_object_color_system"
	M.UpdateAISystem = require "world.ecs.systems.update_ai_system"
	M.UpdateWeaponsSystem = require "world.ecs.systems.update_weapons_system"
	M.CameraBobSystem = require "world.ecs.systems.camera_bob_system"
end

M.load()

return M