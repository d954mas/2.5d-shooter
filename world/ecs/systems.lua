local M = {}
M.CameraSystem = require "world.ecs.systems.update_camera_system"
M.InputSystem = require "world.ecs.systems.input_system"
M.MovementSystem = require "world.ecs.systems.movement_system"
M.UpdateGoSystem = require "world.ecs.systems.update_go_system"
M.PhysicsObstaclesSystem = require "world.ecs.systems.physics_obstacles_system"
M.PhysicsResetCorrectionsSystem = require "world.ecs.systems.physics_reset_corrections_system"
M.LookAtPlayerSystem = require "world.ecs.systems.look_at_player_system"
M.GlobalRotationSystem = require "world.ecs.systems.global_rotation_system"

M.DrawObjectsSystem = require "world.ecs.systems.draw_objects_system"
M.DrawWallsSystem = require "world.ecs.systems.draw_walls_system"
M.UpdateObjectColor = require "world.ecs.systems.update_object_color"

return M