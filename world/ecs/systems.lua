local M = {}
M.CameraSystem = require "world.ecs.systems.update_camera_system"
M.InputSystem = require "world.ecs.systems.input_system"
M.DirectionToVelocitySystem = require "world.ecs.systems.direction_to_velocity_system"
M.MovementSystem = require "world.ecs.systems.movement_system"

return M