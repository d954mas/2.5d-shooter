local M = {}

M.OBJECT_HASHES = {
	root = hash("/root"),
	sprite = hash("/sprite"),
	collision_damage = hash("/collision_damage"),
}

M.COMPONENT_HASHES = {
	sprite = hash("sprite")
}

M.FACTORY = {
	empty = msg.url("game:/factories#factory_empty"),
	block = msg.url("game:/factories#factory_block"),
	enemy_blob = msg.url("game:/factories#factory_enemy_blob"),
	pickup = msg.url("game:/factories#factory_pickup"),
	sprite =  msg.url("game:/factories#factory_sprite_object"),
	sprite_wall = msg.url("game:/factories#factory_sprite_wall"),
	blood_particle = msg.url("game:/factories#factory_particle_blood")
}





return M