extends Node

const CLIMB_SFX = preload("res://Sound Effects/Climb.mp3")


@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var edge_detectors : Node2D
@export var wall_detectors : Node2D


func _physics_process(_delta):
	if player.current_state == player.States.CLIMB:
		_main()

func _main():
	## All of the different actions possible in the current state go here
	#region Main
	var direction = Input.get_axis("Up", "Down") ## Accesses the current input
	
	if direction != 0:
		player.velocity.y = player.main_vars.climbing_vars.climbing_speed * direction
		sprite.play("climb")
	
	else:
		sprite.play("climb")
		sprite.stop()
		player.velocity.y = 0
	
	if sprite.frame == 1 or sprite.frame == 3:
		player._play_sound(CLIMB_SFX)
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if not edge_detectors.on_edge():
		player.switch(player.States.CLIMB, player.States.GROUND)
	
	if Input.is_action_just_pressed("Jump"):
		player.switch(player.States.CLIMB, player.States.AIR)
	
	if player.is_on_floor():
		player.switch(player.States.CLIMB, player.States.GROUND)
	
	elif wall_detectors.touching_wall() == false:
		player.switch(player.States.CLIMB, player.States.AIR)
	#endregion
