extends Node

var player_positions_y : Array[float]

var player_outfits = [
	preload("res://Recourses/PlayerSprites/Climber1.tres"),
	preload("res://Recourses/PlayerSprites/Climber2.tres"),
	]

var goal_position_y : float

signal winner (name)

signal reset

signal left_lobby

signal paused
