local COMMON = require "libs.common"
local StatesBase = require "world.states_base"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
local SOUNDS = require "libs.sounds"
local EMPTY_SHOT_DELAY = 0.3 --try shot without ammo
---@type ENTITIES
local ENTITIES

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
	ENTITIES = ENTITIES or requiref ("world.ecs.entities.entities")
	StatesBase.initialize(self,WEAPON_STATES,e,game_controller)
	self.ptototype = WEAPON_PROTOTYPES.check_prototype(prototype)
	self:change_state(WEAPON_STATES.HIDE)
end

function Weapon:on_pressed()
	self.btn_pressed = true
	if self.ptototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.ON_PRESSED then
		self:shoot()
	end
end
function Weapon:pressed()
end
function Weapon:on_released()
	self.btn_pressed = false
	if self.ptototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.ON_RELEASED then
		self:shoot()
	end
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

function Weapon:_raycast()
	local start_point = vmath.vector3(self.e.position.x,0.5,-self.e.position.y)
	local direction =  self:get_direction()
	local end_point = start_point +  direction * self.ptototype.raycast_max_dist
	local raycast = physics.raycast(start_point,end_point,WEAPON_PROTOTYPES.TARGET_HASHES[self.ptototype.target])
	if raycast then
		local target = ENTITIES.get_entity_for_url(msg.url(raycast.id),true)
		--target can be nil. That mean hit obstacle
		if target then
			self.game_controller.level.ecs_world:add_entity(ENTITIES.create_raycast_damage_info(self.e,target,self.ptototype,raycast))
		end
		self.game_controller.level.ecs_world:add_entity(ENTITIES.create_hit_info(self.e,target,self.ptototype,raycast))
	end
	COMMON.coroutine_wait(self.ptototype.shoot_time_delay or 0)
end

function Weapon:get_direction()
	if self.ptototype.player_weapon then
		return vmath.rotate(vmath.quat_rotation_y(self.e.angle.x),vmath.vector3(0,0,-1))
	else
		local dist = vmath.normalize(self.game_controller.level.player.position - self.e.position)
		dist.z = -dist.y
		dist.y = 0
		return dist
	end
end

function Weapon:shoot_co()
	self:change_state(WEAPON_STATES.SHOOTING)
	if not self:have_ammo() then
		if self.ptototype.sounds.empty then SOUNDS:play_sound(self.ptototype.sounds.empty) end
		COMMON.coroutine_wait(EMPTY_SHOT_DELAY)
		self:change_state(WEAPON_STATES.EQUIPPED)
		return
	end

	if self.ptototype.sounds.shoot then
		SOUNDS:play_sound(self.ptototype.sounds.shoot)
	end
	if self.ptototype.ammo_type ~= WEAPON_PROTOTYPES.AMMO_TYPES.MELEE then
		self.e.ammo[self.ptototype.ammo_type] = self.e.ammo[self.ptototype.ammo_type] - 1
	end
	--TODO FIX HARDCODE
	if self.ptototype.player_weapon then
		sprite.play_flipbook("/weapon#sprite",hash("pistol_shoot"))
	end

	COMMON.coroutine_wait(self.ptototype.first_shot_delay)

	if self.ptototype.attack_type == WEAPON_PROTOTYPES.ATTACK_TYPES.RAYCASTING then self:_raycast() end
	self:change_state(WEAPON_STATES.EQUIPPED)
end

function Weapon:equip()
	if self.state == WEAPON_STATES.HIDE then
		self:change_state(WEAPON_STATES.EQUIPPED)
	end
end

function Weapon:have_ammo()
	return self.ptototype.ammo_type == WEAPON_PROTOTYPES.AMMO_TYPES.MELEE or self.e.ammo[self.ptototype.ammo_type] > 0
end


function Weapon:can_shoot()
	return self:can_shoot_check_state() and self:have_ammo()
end


function Weapon:can_shoot_check_state()
	return self.state == WEAPON_STATES.EQUIPPED
end


return Weapon