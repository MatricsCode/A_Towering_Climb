extends Node

var player_positions_y : Array[float]

var current_outfit = preload("res://Recourses/PlayerSprites/Climber1.tres")

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = not get_tree().paused
