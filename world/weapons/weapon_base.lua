local COMMON = require "libs.common"
local StatesBase = require "world.states_base"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
local SOUNDS = require "libs.sounds"


---@class WeaponStates
local WEAPON_STATES = {
	HIDE = "HIDE", --in user inventory
	EQUIPPED = "EQUIPPED",
	SHOOTING = "SHOOTING",
	RELOADING = "RELOADING"
}

---@class Weapon:StatesBase
local Weapon = COMMON.class("WeaponBase",StatesBase)


---@param e Entity
---@param game_controller GameController
function Weapon:initialize(prototype,e,game_controller)
	StatesBase.initialize(self,WEAPON_STATES,e,game_controller)
	self.ptototype = WEAPON_PROTOTYPES.check_prototype(prototype)
	self:change_state(WEAPON_STATES.HIDE)
end

function Weapon:on_pressed()
	if self.ptototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.ON_CLICK then
		self:shoot()
	end
end
function Weapon:pressed()

end
function Weapon:on_released()

end

function Weapon:update(dt)
	StatesBase.update(self,dt)
	if self.co then
		COMMON.coroutine_resume(self.co,dt)
		if coroutine.status(self.co) == "dead" then self.co = nil end
	end
end


--single shoot
function Weapon:shoot()
	if not self:can_shoot_check_state() then return end
	if self.co then return end
	self.co = coroutine.create(self.shoot_co)
	COMMON.coroutine_resume(self.co,self)
end

function Weapon:shoot_co()
	self:change_state(WEAPON_STATES.SHOOTING)
	if not self:have_ammo() and self.ptototype.sounds.empty then
		SOUNDS:play_sound(self.ptototype.sounds.empty)
		COMMON.coroutine_wait(0.3)
		self:change_state(WEAPON_STATES.EQUIPPED)
		return
	end
	if self.ptototype.sounds.shoot then
		SOUNDS:play_sound(self.ptototype.sounds.shoot)
	end
	self.e.ammo[self.ptototype.ammo_type] = self.e.ammo[self.ptototype.ammo_type] - 1
	sprite.play_flipbook("/weapon#sprite",hash("pistol_shoot"))
	COMMON.coroutine_wait(0.1)
	local player = self.e
	local start_point = vmath.vector3(player.position.x,0.5,-player.position.y)
	local direction =  vmath.rotate(vmath.quat_rotation_y(player.angle.x),vmath.vector3(0,0,-1))
	local end_point = start_point +  direction * 8
	local raycast = physics.raycast(start_point,end_point,{hash("enemy")})
	if raycast then
		---@type ENTITIES
		local entities = requiref("world.ecs.entities.entities")
		self.game_controller.level.ecs_world:remove_entity(entities.get_entity_for_url(msg.url(raycast.id)))
		SOUNDS:play_sound(SOUNDS.sounds.game.monster_blob_die)
	end
	COMMON.coroutine_wait(0.4)
	self:change_state(WEAPON_STATES.EQUIPPED)
end

function Weapon:equip()
	if self.state == WEAPON_STATES.HIDE then
		self:change_state(WEAPON_STATES.EQUIPPED)
	end
end

function Weapon:have_ammo()
	return self.e.ammo[self.ptototype.ammo_type] > 0
end


function Weapon:can_shoot()
	return self:can_shoot_check_state() and self:have_ammo()
end


function Weapon:can_shoot_check_state()
	return self.state == WEAPON_STATES.EQUIPPED
end

function Weapon:have_ammo()
	return self.e.ammo[self.ptototype.ammo_type] > 0
end


return Weapon