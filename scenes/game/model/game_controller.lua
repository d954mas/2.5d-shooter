local COMMON = require "libs.common"
local RX = require "libs.rx"
local LEVELS = require "scenes.game.model.levels"
local EVENTS = require "libs.events"
local SOUNDS = require "libs.sounds"
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

--TODO MOVE TO ENTITY WEAPON
function M:player_shoot()
	if self.level.player.player_shooting then return end
	self.level.player.player_shooting = true
	local can_shoot = self.level.player.ammo.pistol > 0
	SOUNDS:play_sound(can_shoot and SOUNDS.sounds.game.weapon_pistol_shoot or SOUNDS.sounds.game.weapon_pistol_empty)
	if can_shoot then
		self.level.player.ammo.pistol = self.level.player.ammo.pistol - 1
		sprite.play_flipbook("/weapon#sprite",hash("pistol_shoot"),function ()
			self.level.player.player_shooting = false
		end)
		local player = self.level.player
		local start_point = vmath.vector3(self.level.player.position.x,0.5,-self.level.player.position.y)
		local direction =  vmath.rotate(vmath.quat_rotation_y(player.angle.x),vmath.vector3(0,0,-1))
		local end_point = start_point +  direction * 8
		local raycast = physics.raycast(start_point,end_point,{hash("enemy")})
		if raycast then
			timer.delay(0.1,false,function ()
				--kill enemy
				---@type ENTITIES
				local entities = requiref("world.ecs.entities.entities")
				self.level.ecs_world.ecs:removeEntity(entities.get_entity_for_url(msg.url(raycast.id)))
				SOUNDS:play_sound(SOUNDS.sounds.game.monster_blob_die)
			end)
		end
	else
		timer.delay(0.3,false,function ()self.level.player.player_shooting = false end)
	end
end

function M:attack_player()
	if self.level.player.ignore_damage or self.level.player.hp < 0 then return end
	self.level.player.hp = self.level.player.hp - 10
	self.level.player.ignore_damage = true
	timer.delay(1,false,function ()self.level.player.ignore_damage  = false end)
	SOUNDS:play_sound_player_hurt()
	if self.level.player.hp < 0 then
		self.level.player.hp = 0
		if not self.level.game_over then
			self.level.game_over = true
			require("libs.sm.sm"):reload()
		end

	end
end
--@TODO TMP
local hp_pickup = {properties = {{global_rotation = true}},tile_id = 214}
local ammo_pickup = {properties = {{global_rotation = true}},tile_id = 215}
local pickups_weights = {}
pickups_weights[hp_pickup] = 1
pickups_weights[ammo_pickup] = 2
function M:spawn_pickups()
	timer.delay(8,true,function()
		---@type ENTITIES
		local ENTITIES = requiref "world.ecs.entities.entities"
		local pickup = COMMON.LUME.weightedchoice(pickups_weights)
		self.level.ecs_world.ecs:addEntity(ENTITIES.create_pickup(self:get_random_spawn_position()-vmath.vector3(0.5,0.5,0),pickup))
	end)
end

function M:get_random_spawn_position()
	local w,h = self.level:map_get_width(), self.level:map_get_height()
	while true do
		local x,y = math.random(1,w), math.random(1,h)
		local map_cell = self.level:map_get_cell(x,y)
		if not map_cell.blocked  and map_cell.wall.floor ~= -1 then
			return vmath.vector3(x,y,0)
		end
	end
end


function M:weapon_set_bob_offset(offset)
	offset = offset * 200 - 10 -- -10 is dy to hide weapon bottom edge
	local pos = vmath.vector3(960,offset,0)
	go.set_position(pos,"/weapon")
end

function M:on_input(action_id,action)
	self.level.ecs_world:add_entity(ENTITIES.create_input(action_id or COMMON.INPUT.HASH_NIL,action))
end

return M()