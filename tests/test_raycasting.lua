local LEVELS = require "scenes.game.levels.levels"
local SM = require "libs_project.sm"

return function()

	---@param native_cells NativeCellData[]
	local function compareCoords(assert_equal,native_cells,coords)
		assert_equal(#native_cells,#coords)
		for idx,cell in ipairs(native_cells)do
			assert_equal(cell:get_x(),coords[idx][1])
			assert_equal(cell:get_y(),coords[idx][2])
		end
	end

	local function sortCell(cells)
		table.sort(cells,function (c1,c2)
			return c1:get_id()  < c2:get_id()
		end)
	end

	describe("Raycasting", function()
		before(function()
			SM:show(SM.SCENES.GAME_SCENE,{level_id = LEVELS.TESTS.TEST_RAYCASTING},{reload = true})
			while SM.co do coroutine.yield() end
		end)

		after(function()
			SM:back({to_init_collection = true})
			while SM.co do coroutine.yield() end
		end)

		test("distLight360_no_block", function()
			local camera = native_raycasting.camera_new()
			camera:set_max_dist(1)
			camera:set_fov(math.pi*2)
			camera:set_rays(16)
			camera:set_pos(3.5,28.5)

			local cells = native_raycasting.camera_cast_rays(camera,true,true)
			sortCell(cells)
			compareCoords(assert_equal,cells,{{2,27},{3,27},{4,27},{2,28},{3,28},{4,28},{2,29},{3,29},{4,29}})

			camera:set_max_dist(2)
			cells = native_raycasting.camera_cast_rays(camera,true,true)
			sortCell(cells)
			compareCoords(assert_equal,cells,{
				{1,26},{2,26},{3,26},{4,26},{5,26},
				{1,27},{2,27},{3,27},{4,27},{5,27},
				{1,28},{2,28},{3,28},{4,28},{5,28},
				{1,29},{2,29},{3,29},{4,29},{5,29},
				{1,30},{2,30},{3,30},{4,30},{5,30}
			})

			native_raycasting.camera_delete(camera)

		end)

		test("distLight360_2", function()
			local camera = native_raycasting.camera_new()
			camera:set_max_dist(1)
			camera:set_fov(math.pi*2)
			camera:set_rays(16)
			camera:set_pos(1.5,30.5)

			local cells = native_raycasting.camera_cast_rays(camera,true,true)
			sortCell(cells)
			compareCoords(assert_equal,cells,{{1,29},{2,29},{1,30},{2,30}})

			camera:set_max_dist(2)
			cells = native_raycasting.camera_cast_rays(camera,true,true)
			sortCell(cells)
			compareCoords(assert_equal,cells,{{1,28},{2,28},{3,28},{1,29},{2,29},{3,29},{1,30},{2,30},{3,30}})

			native_raycasting.camera_delete(camera)

		end)--[[
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