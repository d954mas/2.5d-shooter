local COMMON = require "libs.common"
local StatesBase = require "world.states_base"
local WEAPON_PROTOTYPES = require "world.weapons.weapon_prototypes"


---@class WeaponStates
local WEAPON_STATES = {
	HIDE = "HIDE", --in user inventory
	EQUIPPED = "EQUIPPED",
	SHOOTING = "SHOOTING",
	RELOADING = "RELOADING"
}
local TAG = "Weapon"
---@class Weapon
local Weapon = COMMON.class("WeaponBase",StatesBase)





---@param e Entity
---@param game_controller GameController
function Weapon:initialize(prototype,e,game_controller)
	StatesBase.initialize(self,WEAPON_STATES,e,game_controller)
	self.ptototype = WEAPON_PROTOTYPES.check_prototype(prototype)
	self:change_state(self.states.HIDE)
end




return Weapon