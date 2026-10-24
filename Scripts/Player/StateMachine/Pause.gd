extends Node

signal switch(new_state, additional)

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var edge_detectors : Node2D
@export var wall_detectors : Node2D

func _main():
	if wall_detectors.touching_wall() == false and not player.is_on_floor():
	
		if player.velocity.y < player.MAX_GRAVITY: # Checks and adjusts the current gravity
			player.velocity.y += player.main_vars.air_vars.gravity
			player.main_vars.air_vars.gravity += 1
			sprite.play("fall")
	
	elif player.wall_detectors.touching_wall() == true and not player.is_on_floor():
		#sprite.stop()
		player.velocity.y = 0
	
	elif player.wall_detectors.touching_wall() == true and player.is_on_floor():
		player.position.x += player.get_sprite_rotation() * -1 * 20
		sprite.play("idle")
	
	else:
		sprite.play("idle")
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.4)
