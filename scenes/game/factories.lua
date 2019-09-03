local M = {}

M.OBJECT_HASHES = {
	root = hash("/root"),
	sprite = hash("/sprite"),
	collision_damage = hash("/collision_damage"),
	block_collider = hash("/root/block_collider"),
	action_collider = hash("/root/action_collider"),
}

M.COMPONENT_HASHES = {
	sprite = hash("sprite")
}

M.FACTORY_COLLECTION = {
	door = msg.url("game:/factories#factory_door"),
	enemy_blob = msg.url("game:/factories#factory_enemy_blob"),
}

M.FACTORY = {
	empty = msg.url("game:/factories#factory_empty"),
	block = msg.url("game:/factories#factory_block"),
	pickup = msg.url("game:/factories#factory_pickup"),
	sprite =  msg.url("game:/factories#factory_sprite_object"),
	sprite_wall = msg.url("game:/factories#factory_sprite_wall"),
	blood_particle = msg.url("game:/factories#factory_particle_blood")
}





return M