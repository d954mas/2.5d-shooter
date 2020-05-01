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
	M.UpdateLightSystem = require "model.battle.ecs.systems.update_light_system"
	M.AutoDestroySystem = require "model.battle.ecs.systems.auto_destroy_system"
	M.CameraBobSystem = require "model.battle.ecs.systems.camera_bob_system"
	M.InputSystem = require "model.battle.ecs.systems.input_system"
	M.MovementSystem = require "model.battle.ecs.systems.movement_system"
	M.RotationGlobalSystem = require "model.battle.ecs.systems.rotation_global_system"
	M.RotationLookAtPlayerSystem = require "model.battle.ecs.systems.rotation_look_at_player_system"
	M.RotationSpeedSystem = require "model.battle.ecs.systems.rotation_speed_system"
	M.UpdateAISystem = require "model.battle.ecs.systems.update_ai_system"
	M.UpdateCameraPositionSystem = require "model.battle.ecs.systems.update_camera_position_system"
	M.UpdateCameraVisibleCellsSystem = require "model.battle.ecs.systems.update_camera_visible_cells_system"
	M.UpdateGoSystem = require "model.battle.ecs.systems.update_go_system"
	M.UpdateObjectColorSystem = require "model.battle.ecs.systems.update_object_color_system"
	M.CheckVisibleSystem = require "model.battle.ecs.systems.check_visible_system"
	M.DrawFloorSystem = require "model.battle.ecs.systems.draw_floor_system"
	M.DrawCeilSystem = require "model.battle.ecs.systems.draw_ceil_system"
	M.DrawWallSystem = require "model.battle.ecs.systems.draw_wall_system"
	M.DrawPickupsSystem = require "model.battle.ecs.systems.draw_pickups_system"
	M.DrawLevelObjectSystem = require "model.battle.ecs.systems.draw_level_object_system"
	M.DrawDebugLightsSystem = require "model.battle.ecs.systems.draw_debug_lights_system"
	M.DrawDebugPhysicsBodiesSystem = require "model.battle.ecs.systems.draw_debug_physics_bodies_system"
	M.UpdatePhysicsBodyPositionsSystem = require "model.battle.ecs.systems.update_physics_body_positions_system"
	M.UpdatePhysicsSystem = require "model.battle.ecs.systems.update_physics_system"
	M.PhysicsCollisionWallSystem = require "model.battle.ecs.systems.physics_collision_wall_system"
	M.PhysicsResetCorrectionSystem = require "model.battle.ecs.systems.physics_reset_correction_system"
	M.LightsDynamicUpdate = require "model.battle.ecs.systems.lights_dynamic_update"
	M.LightsPatternUpdate = require "model.battle.ecs.systems.lights_pattern_update"
end

return M