local M = {}
M.CameraSystem = require "world.ecs.systems.update_camera_system"
M.InputSystem = require "world.ecs.systems.input_system"
M.DirectionToVelocitySystem = require "world.ecs.systems.direction_to_velocity_system"
M.MovementSystem = require "world.ecs.systems.movement_system"
M.UpdateGoSystem = require "world.ecs.systems.update_go_system"
M.PhysicsObstaclesSystem = require "world.ecs.systems.physics_obstacles_system"
M.PhysicsResetCorrectionsSystem = require "world.ecs.systems.physics_reset_corrections_system"

return M