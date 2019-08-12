local COMMON = require "libs.common"
local StatesBase = require "world.states_base"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"
local SOUNDS = require "libs.sounds"
---@type ENTITIES
local ENTITIES

local PLAYER_WEAPON_URL = msg.url("game:/weapon#sprite")

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
	self.prototype = WEAPON_PROTOTYPES.check_prototype(prototype)
	self:change_state(WEAPON_STATES.HIDE)
end

function Weapon:state_changed(old)
	StatesBase.state_changed(self,old)
	if self.state == WEAPON_STATES.EQUIPPED then
		self:play_animation(self.prototype.animations.idle)
	end
end

function Weapon:on_pressed()
	self.btn_pressed = true
	if self.prototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.ON_PRESSED or self.prototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.WHILE_PRESSED then
		self:shoot()
	end
end
function Weapon:pressed()
end
function Weapon:on_released()
	self.btn_pressed = false
	if self.prototype.input_type == WEAPON_PROTOTYPES.INPUT_TYPE.ON_RELEASED then
		self:shoot()
	end
end

function Weapon:update(dt)
	StatesBase.update(self,dt)
	if self.co then
		if coroutine.status(self.co) == "dead" then self.co = nil end
		if self.co then COMMON.coroutine_resume(self.co,dt) end
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
	local end_point = start_point +  direction * self.prototype.raycast_max_dist
	local raycast = physics.raycast(start_point,end_point,WEAPON_PROTOTYPES.TARGET_HASHES[self.prototype.target])
	if raycast then
		local target = ENTITIES.get_entity_for_url(msg.url(raycast.id),true)
		--target can be nil. That mean hit obstacle
		if target then
			self.game_controller.level.ecs_world:add_entity(ENTITIES.create_raycast_damage_info(self.e,target,self.prototype,raycast))
		end
		self.game_controller.level.ecs_world:add_entity(ENTITIES.create_hit_info(self.e,target,self.prototype,raycast))
	end
	COMMON.coroutine_wait(self.prototype.shoot_time_delay or 0)
end

function Weapon:get_direction()
	if self.prototype.player_weapon then
		return vmath.rotate(vmath.quat_rotation_y(self.e.angle.x),vmath.vector3(0,0,-1))
	else
		local dist = vmath.normalize(self.game_controller.level.player.position - self.e.position)
		dist.z = -dist.y
		dist.y = 0
		return dist
	end
end

---@param anim WeaponAnimation
function Weapon:play_animation(anim)
	if self.prototype.player_weapon and anim.animation then
		sprite.play_flipbook(PLAYER_WEAPON_URL,anim.animation)
	end
	COMMON.coroutine_wait(anim.duration)

end

function Weapon:shoot_co()
	self:change_state(WEAPON_STATES.SHOOTING)
	local p = self.prototype

	if not self:have_ammo() then
		if self.prototype.sounds.empty then SOUNDS:play_sound(self.prototype.sounds.empty) end
		self:play_animation(p.animations.shoot_empty)
		self:change_state(WEAPON_STATES.EQUIPPED)
		return
	end

	self:play_animation(p.animations.shoot_first_delay)
	repeat
		self:play_animation(p.animations.shoot_prepare)
		if self.prototype.sounds.shoot then SOUNDS:play_sound(self.prototype.sounds.shoot) end
		if self.prototype.ammo_type ~= WEAPON_PROTOTYPES.AMMO_TYPES.MELEE then
			self.e.ammo[self.prototype.ammo_type] = self.e.ammo[self.prototype.ammo_type] - 1
		end
		if self.prototype.attack_type == WEAPON_PROTOTYPES.ATTACK_TYPES.RAYCASTING then self:_raycast() end
		self:play_animation(p.animations.shoot)
		self:play_animation(p.animations.shoot_after)
	until(not (p.input_type==WEAPON_PROTOTYPES.INPUT_TYPE.WHILE_PRESSED and self:have_ammo() and self.btn_pressed))
	self:change_state(WEAPON_STATES.EQUIPPED)
end

function Weapon:equip()
	if self.state == WEAPON_STATES.HIDE then
		self:change_state(WEAPON_STATES.EQUIPPED)
	end
end

function Weapon:have_ammo()
	return self.prototype.ammo_type == WEAPON_PROTOTYPES.AMMO_TYPES.MELEE or self.e.ammo[self.prototype.ammo_type] > 0
end


function Weapon:can_shoot()
	return self:can_shoot_check_state() and self:have_ammo()
end


function Weapon:can_shoot_check_state()
	return self.state == WEAPON_STATES.EQUIPPED
end


return Weapon