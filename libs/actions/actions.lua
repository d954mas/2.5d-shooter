
local Actions = {}

Actions.Parallel = require "libs.actions.parallel_action"
Actions.Sequence = require "libs.actions.sequence_action"
Actions.Wait = require "libs.actions.wait_action"
Actions.TweenGo = require "libs.actions.tween_action_go"
Actions.TweenGui = require "libs.actions.tween_action_gui"
Actions.TweenTable = require "libs.actions.tween_action_table"
Actions.Shake = require "libs.actions.shake_action"
--Tween({object = char.vh.root, property = "position", easing = "outBounce", v3 = true,
--                                         to = to,from = from, time = time}))
Actions.Function = require "libs.actions.function_action"

return Actions