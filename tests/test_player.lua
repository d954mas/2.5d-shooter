local LEVELS = require "scenes.game.model.levels"
local SM = require "libs.sm.sm"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local ENTITIES = require "world.ecs.entities.entities"
local WEAPONS = require "world.weapons.weapon_prototypes"
local COMMON = require "libs.common"

return function()
	describe("", function()
		before(function()
		end)

		after(function() end)

		test("Ignore damage", function()
			SM:show("GameScene",{level = LEVELS.TESTS.MOVEMENT},{reload = true})
			while SM.co do coroutine.yield() end
			GAME_CONTROLLER.level.ecs_world.systems.UpdateAISystem.active = false
			local player = GAME_CONTROLLER.level.player
			assert_equal(player.hp,100)
			GAME_CONTROLLER.level.ecs_world:add_entity(ENTITIES.create_raycast_damage_info(player,player,WEAPONS.prototypes.ENEMY_MELEE))
			coroutine.yield()
			--test take damage
			assert_equal(player.hp,100- WEAPONS.prototypes.ENEMY_MELEE.damage)
			for i=1,5 do
				GAME_CONTROLLER.level.ecs_world:add_entity(ENTITIES.create_raycast_damage_info(player,player,WEAPONS.prototypes.ENEMY_MELEE))
				coroutine.yield()
				assert_equal(player.hp,100- WEAPONS.prototypes.ENEMY_MELEE.damage)
			end
			COMMON.coroutine_wait(4)
			GAME_CONTROLLER.level.ecs_world:add_entity(ENTITIES.create_raycast_damage_info(player,player,WEAPONS.prototypes.ENEMY_MELEE))
			coroutine.yield()
			assert_equal(player.hp,100- WEAPONS.prototypes.ENEMY_MELEE.damage*2)
		end)

	end)
end