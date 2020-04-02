local LEVELS = require "scenes.game.levels.levels"
local SM = require "libs_project.sm"

return function()
	describe("Levels Load", function()
		before(function()
		end)

		after(function() end)

		test("Loading all jsons", function()
			for _, level in pairs(LEVELS.TESTS)do
				assert_not_empty(LEVELS.load_level(level))
			end
			for _, level in pairs(LEVELS.LEVELS)do
				assert_not_empty(LEVELS.load_level(level))
			end
		end)
		test("Error load unknown level", function()
			assert_false(pcall(LEVELS.load_level,"no such json"))
		end)
		test("Open all levels", function()
			local old_assert = _G.assert
			local asserts = 0
			_G.assert = function(...)
				local status, result =  pcall(old_assert,...)
				if not status then asserts = asserts + 1 old_assert(...) end
				return result
			end

			for _, level in pairs(LEVELS.TESTS)do
				asserts = 0
				print("load:" .. level)
				SM:show(SM.SCENES.GAME_SCENE,{level_id = level},{reload = true})
				while SM.co do coroutine.yield() end
				assert_true(asserts==0,"asserts:" .. asserts .. " happened while show scene")
			end
			for _, level in pairs(LEVELS.LEVELS)do
				asserts = 0
				SM:show(SM.SCENES.GAME_SCENE,{level_id = level},{reload = true})
				while SM.co do coroutine.yield() end
				assert_true(asserts==0,"asserts:" .. asserts .. " happened while show scene")
			end
			print("BACK")
			SM:back({to_init_collection = true})
			while SM.co do coroutine.yield() end
			_G.assert = old_assert
		end)
	end)
end