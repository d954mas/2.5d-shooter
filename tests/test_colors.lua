local COMMON = require "libs.common"

return function()
	describe("Parser", function()
		before(function()
		end)

		after(function()
			-- this function will be run after each test
		end)

		test("test rgb to hsv", function()
			local function check_hsv(h1, s1, v1, h2, s2, v2)
				assert_equal(math.ceil(h1), h2)
				assert_equal(COMMON.LUME.round(s1, 0.001), s2)
				assert_equal(COMMON.LUME.round(v1, 0.001), v2)
			end
			local h, s, v = native_raycasting.color_rgb_to_hsv(0xffffff)
			check_hsv(h, s, v, 0, 0, 1)

			h, s, v = native_raycasting.color_rgb_to_hsv(0x000000)
			check_hsv(h, s, v, 0, 0, 0)

			h, s, v = native_raycasting.color_rgb_to_hsv(0x2342ff)
			check_hsv(h, s, v, 232, 0.863, 1)

			h, s, v = native_raycasting.color_rgb_to_hsv(0xDE3721)
			check_hsv(h, s, v, 7, 0.851, 0.871)
		end)

		test("test hsv to rgb", function()
			assert_equal(0xffffff, native_raycasting.color_hsv_to_rgb(0, 0, 1))
			assert_equal(0x000000, native_raycasting.color_hsv_to_rgb(0, 0, 0))
			assert_equal(0x2342ff, native_raycasting.color_hsv_to_rgb(231.5, 0.8627, 1))
			assert_equal(0xDE3721, native_raycasting.color_hsv_to_rgb(7, 0.851, 0.871))
		end)

		test("test rgb to hsv and back", function()
			local function check_color(c1, c2)
				local r1, r2 = bit.arshift(bit.band(c1, 0x00FF0000), 16) , bit.arshift(bit.band(c2, 0x00FF0000), 16)
				local g1, g2 = bit.arshift(bit.band(c1, 0x0000FF00), 8) , bit.arshift(bit.band(c2, 0x0000FF00), 8)
				local b1, b2 = bit.arshift(bit.band(c1, 0x000000FF), 0) , bit.arshift(bit.band(c2, 0x000000FF), 0)
				assert_lte(math.abs(r1-r2),1) --color can be different because of float accuracy. But only for 1 value.
				assert_lte(math.abs(g1-g2),1)
				assert_lte(math.abs(b1-b2),1)
			end

			local color = 0xffffff
			local h, s, v = native_raycasting.color_rgb_to_hsv(color)
			local new_color = native_raycasting.color_hsv_to_rgb(h, s, v)
			check_color(color, new_color)

			color = 0x000000
			h, s, v = native_raycasting.color_rgb_to_hsv(color)
			new_color = native_raycasting.color_hsv_to_rgb(h, s, v)
			check_color(color, new_color)

			color = 0x2342ff
			h, s, v = native_raycasting.color_rgb_to_hsv(color)
			new_color = native_raycasting.color_hsv_to_rgb(h, s, v)
			check_color(color, new_color)

			color = 0xDE3721
			h, s, v = native_raycasting.color_rgb_to_hsv(color)
			new_color = native_raycasting.color_hsv_to_rgb(h, s, v)
			check_color(color, new_color)
		end)
	end)
end