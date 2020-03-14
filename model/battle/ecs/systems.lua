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
	M.AutoDestroySystem = require "model.battle.ecs.systems.auto_destroy_system"
	M.CameraBobSystem = require "model.battle.ecs.systems.camera_bob_system"
	M.InputSystem = require "model.battle.ecs.systems.input_system"
	M.MovementSystem = require "model.battle.ecs.systems.movement_system"
	M.RotationGlobalSystem = require "model.battle.ecs.systems.rotation_global_system"
	M.RotationLookAtPlayerSystem = require "model.battle.ecs.systems.rotation_look_at_player_system"
	M.UpdateAISystem = require "model.battle.ecs.systems.update_ai_system"
	M.UpdateCameraSystem = require "model.battle.ecs.systems.update_camera_system"
	M.UpdateGoSystem = require "model.battle.ecs.systems.update_go_system"
	M.UpdateObjectColorSystem = require "model.battle.ecs.systems.update_object_color_system"
end

return M