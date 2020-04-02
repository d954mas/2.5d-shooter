
return function()
	describe("Pathfinding", function()
		before(function()
			-- this function will be run before each test
		end)

		after(function()
			-- this function will be run after each test
		end)
	--[[	local start_point
		test("Load pathfinding level", function()
			local old_assert = _G.assert
			local asserts = 0
			_G.assert = function(...)
				local status, result =  pcall(old_assert,...)
				if not status then asserts = asserts + 1 old_assert(...) end
				return result
			end
			SM:show("GameScene",{level = LEVELS.TESTS.MOVEMENT})
			while SM.co do coroutine.yield() end
			assert_true(asserts==0,"asserts:" .. asserts .. " happened while show scene")
			_G.assert = old_assert
			start_point = GAME_CONTROLLER.level.player.position
		end)
		---@param path NativeCellData[]
		local validate_path 
		test("Path same cell", function()
			validate_path = function(path,excepted_path)
				assert_not_blank(path)
				assert_equal(#path,#excepted_path)
				for i,v in ipairs(path)do
					assert_equal(v:get_x(),excepted_path[i][1])
					assert_equal(v:get_y(),excepted_path[i][2])
				end
			end
			local path = native_raycasting.map_find_path(start_point.x,start_point.y,start_point.x,start_point.y)
			validate_path(path,{{5,5}})
		end)
		test("Path near wallcable cell", function()
			local path = native_raycasting.map_find_path(5,5,6,5)
			validate_path(path,{{5,5},{6,5}})
			path = native_raycasting.map_find_path(5,5,4,5)
			validate_path(path,{{5,5},{4,5}})
			path = native_raycasting.map_find_path(5,5,5,4)
			validate_path(path,{{5,5},{5,4}})
		end)
		test("Path near blocked cell", function()
			local path = native_raycasting.map_find_path(5,5,5,6)
			assert_blank(path)
		end)
		test("Path near diagonal one step", function()
			local path = native_raycasting.map_find_path(5,5,4,4)
			validate_path(path,{{5,5},{4,4}})
			path = native_raycasting.map_find_path(5,5,6,4)
			validate_path(path,{{5,5},{6,4}})
		end)
		test("Path blocked diagonal move", function()
			local path = native_raycasting.map_find_path(5,5,4,6)
			validate_path(path,{{5,5},{4,5},{4,6}})
			path = native_raycasting.map_find_path(5,5,6,6)
			validate_path(path,{{5,5},{6,5},{6,6}})
		end)
		test("Path unknow cell", function()
			local path = native_raycasting.map_find_path(5,5,400,6)
			assert_blank(path)
		end)
		test("Path negative coords", function()
			assert_blank(native_raycasting.map_find_path(-1,1,1,1))
			assert_blank(native_raycasting.map_find_path(1,-1,1,1))
			assert_blank(native_raycasting.map_find_path(1,1,-1,1))
			assert_blank(native_raycasting.map_find_path(1,1,1,-1))
		end)
		test("Path double coords", function()
			validate_path(native_raycasting.map_find_path(1,1,1,1),{{1,1}})
			validate_path(native_raycasting.map_find_path(2,1,2,1),{{2,1}})
			validate_path(native_raycasting.map_find_path(0.99,1,1,1),{{1,1}})
			validate_path(native_raycasting.map_find_path(1.01,1,2,1),{{2,1}})
		end)
		test("Path to wall", function()
			local path = native_raycasting.map_find_path(5,5,1,9)
			assert_blank(path)
		end)
		test("Path 1", function()
			local path = native_raycasting.map_find_path(5,5,9,9)
			validate_path(path,{{5,5},{6,5},{7,6},{8,7},{9,8},{9,9}})
			path = native_raycasting.map_find_path(9,9,5,5)
			validate_path(path,{{9,9},{9,8},{8,7},{7,6},{6,5},{5,5}})
		end)
		test("Path 2", function()
			local path = native_raycasting.map_find_path(5,5,7,9)
			validate_path(path,{{5,5},{4,5},{4,6},{4,7},{5,8},{6,9},{7,9}})
			path = native_raycasting.map_find_path(7,9,5,5)
			validate_path(path,{{7,9},{6,9},{5,8},{4,7},{4,6},{4,5},{5,5}})
		end)--]]
	end)
end