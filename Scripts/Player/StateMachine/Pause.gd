extends Node

signal switch(new_state, additional)

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

var current := false

var fall_speed := 0.0

func _physics_process(delta):
	if player.current_state != player.States.PAUSED:
		current = false
		return
	elif player.current_state == player.States.PAUSED:
		current = true
	
	_paused()

func _paused():
	if !detectors.is_on_wall and !detectors.is_on_ground:
		
		if fall_speed < player.TERMINAL_VELOCITY: # Checks and adjusts the current gravity
			fall_speed += player.main_vars.air_vars.gravity
			player.main_vars.air_vars.gravity += player.main_vars.air_vars.gravity_increase
		
		if fall_speed > -150 and fall_speed < 0:
			fall_speed = 100
		
		player.velocity.y = fall_speed
	elif detectors.is_on_wall and !detectors.is_on_ground:
		player.velocity = Vector2.ZERO
		sprite.play("climb")
		sprite.stop()
		player.velocity.y = 0
	elif detectors.is_on_wall and detectors.is_on_ground:
		player.position.x += player._get_sprite_rotation() * -1 * 20
		player.velocity = Vector2.ZERO
		sprite.play("idle")
	
	else:
		player.velocity = Vector2.ZERO
		sprite.play("idle")
