local LEVELS = require "scenes.game.model.levels"
local SM = require "libs.sm.sm"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"

return function()
	describe("Parser", function()
		before(function()
			-- this function will be run before each test
		end)

		after(function()
			-- this function will be run after each test
		end)
		---@type Level
		local level
		local v3 = vmath.vector3
		local assert_posv2
		local check_coords
		test("test objects pos", function()
			assert_posv2 = function(v1,v2)
				assert(v1)
				assert(v2)
				assert_true(v1.x == v2.x and v1.y == v2.y,"not equal pos:(" .. v1.x .. " "  .. v1.y .. ") (" .. v2.x .. " " .. v2.y .. ")")
			end
			check_coords = function(data,coords,ignore_snap_to_grid)
				assert_equal(#coords,#data)
				for i, obj in ipairs(data)do
					assert_posv2(v3(obj.cell_x,obj.cell_y,0),coords[i])
					assert_posv2(v3(obj.cell_x,obj.cell_y,0),v3(math.ceil(coords[i].x),math.ceil(coords[i].y),0))
					if not ignore_snap_to_grid then
						assert_posv2(v3(obj.cell_xf,obj.cell_yf,0),vmath.vector3(coords[i].x - 0.5, coords[i].y - 0.5,0))
					end
				end
			end
			level = LEVELS.load_level(LEVELS.TESTS.PARSER)
			local data = level.data
			check_coords(data.objects, {v3(6,7,0)})
			check_coords(data.enemies,  {v3(3,4,0),v3(5,6,0)})
			check_coords(data.pickups,{v3(8,2,0),v3(2,9,0)})
		end)
		test("test ignore snap to grid", function()
			--impl when need that logic
		end)
	end)
end