local COMMON = require "libs.common"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
---@type ENTITIES
local ENTITIES --for projectiles

local Weapon = COMMON.class("WeaponBase")

---@param data WeaponData
---@param e Entity hero|enemy.
---@param game_controller GameController
function Weapon:initialize(data,e,game_controller)
	ENTITIES = ENTITIES or requiref ("world.ecs.entities.entities")
	self.data = assert(data)
	self.e = assert(e)
	self.game_controller = assert(game_controller)
	self.co_shooting = nil
	--hide/show coroutine -- hide show is forced. It will ignore current update
	self.co_show = nil
end

--region Input
function Weapon:input_on_pressed()
	self.btn_pressed = true
	if not self.co_shooting and not self.co_show then
		self.co_shooting = coroutine.create()
		COMMON.coroutine_resume(self.co_shooting,self,0)
	end
end

function Weapon:input_check_pressed() return COMMON.INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT_TOUCH] end
--endregion

function Weapon:show_f() end
function Weapon:hide_f() end

function Weapon:show()
	if not self.co_show then
		self.co_show = coroutine.create(self.show_f)
		self.co_show = COMMON.coroutine_resume(self.co_show,self)
	end
end

--hide can ovveride current show animation
function Weapon:hide()
	self.btn_pressed = false
	self.co_show = coroutine.create(self.hide_f)
	self.co_show = COMMON.coroutine_resume(self.co_show,self)
end


function Weapon:update_f(dt)
	self.btn_pressed = self.btn_pressed and self:input_check_pressed()
	if self.co_show then
		self.co_show = COMMON.coroutine_resume(self.co_show,dt)
		if not self.co_show then self.co_shooting = nil end
	end
	if self.co_shooting then
		self.co_shooting = COMMON.coroutine_resume(self.co_shooting,dt)
	end
end

function Weapon:shooting(dt)

end


return Weapon