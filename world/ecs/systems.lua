local M = {}
M.CameraSystem = require "world.ecs.systems.update_camera_system"
M.InputSystem = require "world.ecs.systems.input_system"
M.MovementSystem = require "world.ecs.systems.movement_system"
M.UpdateGoSystem = require "world.ecs.systems.update_go_system"
M.PhysicsObstaclesSystem = require "world.ecs.systems.physics_obstacles_system"
M.PhysicsResetCorrectionsSystem = require "world.ecs.systems.physics_reset_corrections_system"
M.RotationLookAtPlayerSystem = require "world.ecs.systems.rotation_look_at_player_system"
M.RotationGlobalSystem = require "world.ecs.systems.rotation_global_system"

M.DrawObjectsSystem = require "world.ecs.systems.draw_objects_system"
M.DrawWallsSystem = require "world.ecs.systems.draw_walls_system"
M.UpdateObjectColor = require "world.ecs.systems.update_object_color"

return M