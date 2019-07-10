local COMMON = require "libs.common"
local M = {}

M.ATTACK_TYPES = COMMON.read_only{
	RAYCASTING = "RAYCASTING",
	PROJECTILE = "PROJECTILE"
}

M.AMMO_TYPES = COMMON.read_only{
	PISTOL = "PISTOL"
}

M.INPUT_TYPE = COMMON.read_only{
	ON_CLICK = "ON_CLICK", --single shot for every click. Pistol
	WHILE_PRESSED = "WHILE_PRESSED" --shooting while pressed. Machine gun

}
---@class WeaponPrototype
---@field attack_type string
---@field ammo_type string
---@field raycast_max_dist number
---@field reload_time number|nil
---@field clip number|nil
---@field input_type string
---@field player_weapon boolean|nil player_weapon should have icon, and animations for states.

---@param ptototype WeaponPrototype
function M.check_prototype(ptototype)
	assert(ptototype,"prototype can't be nil")
	assert(ptototype.attack_type, "attack type can't be nil")
	if ptototype.attack_type == M.ATTACK_TYPES.RAYCASTING then
		assert(type(ptototype.raycast_max_dist)== "number","bad raycast_max_dist:" .. tostring(ptototype.raycast_max_dist))
		assert(ptototype.raycast_max_dist>0,"raycast_max_dist should be bigger 0")
	elseif ptototype.attack_type== M.ATTACK_TYPES.PROJECTILE then

	else
		assert(nil,"unknown weapon attack_type:" .. ptototype.attack_type)
	end
	assert(M.AMMO_TYPES[ptototype.ammo_type],"unknown ammo type:" .. tostring(ptototype.ammo_type))
	assert(M.INPUT_TYPE[ptototype.input_type],"unknown input type:" .. tostring(ptototype.input_type))
	if ptototype.clip then
		assert(ptototype.reload_time,"need reload time,when have clip")
	end
	return ptototype
end

M.prototypes = COMMON.read_only_recursive{
	PISTOL = {attack_type = M.ATTACK_TYPES.RAYCASTING,ammo_type = M.AMMO_TYPES.PISTOL, raycast_max_dist = 10, reload_time = 0,
	input_type = M.INPUT_TYPE.ON_CLICK}
}

return M