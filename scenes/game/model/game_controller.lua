local COMMON = require "libs.common"
local RX = require "libs.rx"
local LEVELS = require "scenes.game.model.levels"
local EVENTS = require "libs.events"
local ENTITIES = require "world.ecs.entities.entities"
local RENDER_CAM = require "rendercam.rendercam"

local CAMERA_RAYS = 512
local CAMERA_MAX_DIST = 50
local TAG = "GameController"
--UPDATED FROM GAME COLLECTION

---@class GameController
local M = COMMON.class("GameController")

function M:reset()
	if self.level then self.level:dispose() end
	self.level = nil
	ENTITIES.clear()
end

function M:initialize()
	ENTITIES.set_game_controller(self)
	self.rx = RX.Subject()
	self:reset()
	self:camera_configure()
	COMMON.EVENT_BUS:subscribe(COMMON.EVENTS.WINDOW_RESIZED):subscribe(function()
		--called from render context
		self:camera_update_fov()
	end)
end

--region camera
function M:camera_configure()
	native_raycasting.camera_set_rays(CAMERA_RAYS)
	native_raycasting.camera_set_max_distance(CAMERA_MAX_DIST)
end

function M:camera_update_fov()
	if self.level then
		local aspect = RENDER_CAM.window.x/RENDER_CAM.window.y
		local v_fov = assert(RENDER_CAM.get_current_camera(),"no active camera").fov
		local h_fov = 2 * math.atan( math.tan( v_fov / 2 ) * aspect );
		native_raycasting.camera_set_fov(h_fov*1.2) --use bigger fov then visible
	end
end
--endregion

function M:load_level(name)
	assert(not self.level,"lvl already loaded")
	self.level = LEVELS.load_level(name)
	native_raycasting.map_set(self.level.data)
	self.level:prepare()
	self:camera_update_fov()
	COMMON.EVENT_BUS:event(EVENTS.GAME_LEVEL_MAP_CHANGED)
	self:spawn_pickups()
end

function M:update(dt) end

function M:post_update(dt)
	if self.level then self.level:update(dt) end
end

function M:dispose()
	self:reset()
	if self.subscriptions then	self.subscriptions:unsubscribe() end
	self.subscriptions = nil
end

function M:player_receive_damage()
	RENDER_CAM.rotation(vmath.vector3(0.05,0.1,0.025)*10,0.5,0.8)
end

--region Utils
--TODO CAN LOOP INFINITY
--TODO FIX PERFORMANCE
function M:utils_get_random_spawn_position()
	local w,h = self.level:map_get_width(), self.level:map_get_height()
	while true do
		local x,y = math.random(1,w), math.random(1,h)
		local map_cell = self.level:map_get_cell(x,y)
		if not map_cell.blocked and not map_cell.empty then
			return vmath.vector3(x-0.5,y-0.5,0)
		end
	end
end
--TODO FIX PERFORMANCE
function M:utils_get_random_spawn_position_greater_than(distance,max_tries)
	max_tries = max_tries or math.huge()
	for _=1,max_tries do
		local spawn_pos = self:utils_get_random_spawn_position()
		if spawn_pos and vmath.length(self.level.player.position-spawn_pos) >= distance then
			return spawn_pos
		end
	end
end

---@return NativeCellData[]
function M:utils_find_path_to_player(start_pos)
	return native_raycasting.map_find_path(start_pos.x,start_pos.y,
										   math.ceil(self.level.player.position.x),math.ceil(self.level.player.position.y))
end

--endregion


--@TODO TMP
local hp_pickup = {properties = {{global_rotation = true}},tile_id = 215}
local ammo_pickup = {properties = {{global_rotation = true}},tile_id = 216}
local pickups_weights = {}
pickups_weights[hp_pickup] = 1
pickups_weights[ammo_pickup] = 2
function M:spawn_pickups()
	timer.delay(8,true,function()
		local pickup = COMMON.LUME.weightedchoice(pickups_weights)
		self.level.ecs_world.ecs:addEntity(ENTITIES.create_pickup(self:utils_get_random_spawn_position(),pickup))
	end)
end

function M:on_resume()
	self.level.ecs_world:add_entity(ENTITIES.create_input(COMMON.HASHES.INPUT_NEED_CHECK,{}))
end

function M:on_input(action_id,action)
	self.level.ecs_world:add_entity(ENTITIES.create_input(action_id or COMMON.INPUT.HASH_NIL,action))
end

return M()