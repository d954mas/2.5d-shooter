local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"

local Bar = COMMON.class("Bar")

function Bar:initialize(root_name)
    self.vh = {
        root = gui.get_node(root_name .. "/root"),
        bg = gui.get_node(root_name .. "/bg"),
        progress = gui.get_node(root_name .. "/progress"),
        lbl = nil
    }
    local status, lbl = pcall(gui.get_node, root_name .. "/lbl")
    if status then
        self.vh.lbl = lbl
        local center = vmath.vector3(gui.get_size(self.vh.bg).x / 2, gui.get_position(self.vh.progress).y, 0)
        gui.set_position(self.vh.lbl, center)
    end
    self.value_max = 100
    self.value = 0
    self.value_animated = self.value
    self.padding_progress = gui.get_position(self.vh.progress).x
    self.progress_width_max = gui.get_size(self.vh.bg).x - self.padding_progress * 2
    self.animation_config = {
        time = 1,
        easing = "outCubic"
    }
    self.animation = {
        value = 0,
        tween = nil
    }

    self:set_value(self.value)
    self:gui_update()
end

function Bar:set_value_max(value)
    assert(value > 0)
    self.value_max = value
    self:gui_update()
end

function Bar:update(dt)
    if self.animation.tween and not self.animation.tween:is_finished() then
        self.animation.tween:update(dt)
        self:gui_update()
    end
end

function Bar:gui_update()
    if self.vh.lbl then
        gui.set_text(self.vh.lbl, math.ceil(self.animation.value) .. "/" .. self.value_max)
    end
    gui.set_size(self.vh.progress, vmath.vector3(self.progress_width_max * self.animation.value / self.value_max, gui.get_size(self.vh.progress).y, 0))
end

function Bar:set_value(value)
    if self.animation.tween then
        self.animation.tween:force_finish()
        self.animation.tween = nil
    end
    self.animation.tween = ACTIONS.Tween { object = self.animation, property = "value", from = { value = self.value }, to = { value = value }, time = self.animation_config.time,
                                           easing = self.animation_config.easing }
    self.value = COMMON.LUME.clamp(value, 0, self.value_max)
end

return Bar