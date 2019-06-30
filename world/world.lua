local COMMON = require "libs.common"
local RX = require "libs.rx"
local STATE = require "world.state.state"
local TAG = "World"
local RESET_SAVE = false
local LEVELS = require "world.model.levels"
local EVENTS = require "libs.events"
local LevelView = require "world.view.level_view"
local SOUNDS = require "libs.sounds"

--IT IS GAME WORLD
--UPDATED FROM GAME COLLECTION

---@class World:Observable
local M = COMMON.class("World")

function M:reset()
	if self.level then	self.level:dispose() end
	if self.level_view then self.level_view:dispose() end
	self.level = nil
	self.level_view = nil
end

function M:initialize()
	self.rx = RX.Subject()
	self.state = STATE
	self.autosave = true
	self.autosave_dt = 0
	self.autosave_time = 5
	self:reset()
end

function M:load_level(name)
	assert(not self.level,"lvl alredy loaded")
	self.level = LEVELS.load_level(name)
	self.level:prepare()
	self.level_view = LevelView()
	self.level_view:build_level(self.level)
	COMMON.EVENT_BUS:event(EVENTS.GAME_LEVEL_MAP_CHANGED)
	self:spawn_pickups()
end

function M:update(dt)
	self:process_autosave(dt)
end


function M:post_update(dt)
	if self.level then self.level:update(dt) end
	if self.level_view then self.level_view:update(dt) end
end

function M:process_autosave(dt)
	if self.autosave then
		self.autosave_dt = self.autosave_dt + dt
		if self.autosave_dt > self.autosave_time then
			self.autosave_dt = 0
			self:save()
		end
	end
end


function M:save()
	--COMMON.i("save state",TAG)--pprint(state)
	sys.save(sys.get_save_file("world","data"),  {state = self.state:save()})
end

function M:load()
	local data =  RESET_SAVE and {} or sys.load(sys.get_save_file("world", "data"))
	if not data.state then
		self.state:init_default()
		return
	end
	COMMON.i("load state",TAG)
	self.state:load(data.state,self)
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
local hp_pickup = {properties = {{global_rotation = true}},tile_id = 217}
local ammo_pickup = {properties = {{global_rotation = true}},tile_id = 218}
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

return M()