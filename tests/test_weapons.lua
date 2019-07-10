local Weapon = require "world.weapons.weapon_base"
local WeaponPrototypes = require "world.weapons.weapon_prototypes"
local COMMON = require "libs.common"

return function()
	describe("Weapons", function()
		before(function()
			-- this function will be run before each test
		end)

		after(function()
			-- this function will be run after each test
		end)

		test("Validate base prototypes", function()
			for _,prototype in pairs(WeaponPrototypes.prototypes) do
				assert_not_empty(WeaponPrototypes.check_prototype(prototype))
			end
		end)

		test("Error on validate", function()
			for _,prototype in pairs(WeaponPrototypes.prototypes) do
				---@type WeaponPrototype
				local p2 = COMMON.LUME.clone_deep(prototype.__VALUE or prototype)
				p2.attack_type = "bad value"
				local status = pcall(WeaponPrototypes.check_prototype,p2)
				assert_false(status)
			end

		end)
	end)
end