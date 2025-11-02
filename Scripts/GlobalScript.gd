extends Node

var player_positions_y : Array[float]

var player_outfits = [
	preload("res://Recourses/PlayerSprites/Climber1.tres"),
	preload("res://Recourses/PlayerSprites/Climber2.tres"),
	]

func _physics_process(_delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = not get_tree().paused
