extends Node

var players = Array[CharacterBody2D]

func move(position : Vector2, keep_collisions : bool, animation = ""):
	for player in players:
		player.position = position
		player.current_state = 4
		
		player.set_collision_mask(2, keep_collisions)
		player.set_collision_mask(3, keep_collisions)
		player.set_collision_mask(4, keep_collisions)
		
		player.set_collision_layer(1, keep_collisions)
		player.set_collision_layer(3, keep_collisions)
		
		if animation != "":
			player.sprite.play(animation)

func release():
	for player in players:
		player.current_state = 1
		
		player.set_collision_mask(2, true)
		player.set_collision_mask(3, true)
		player.set_collision_mask(4, true)
		
		player.set_collision_layer(1, true)
		player.set_collision_layer(3, true)
