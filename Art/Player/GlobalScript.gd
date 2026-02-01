extends Node

var player_positions_y : Array[float]

@export var player_outfits : Array[int]

var all_player_outfits = [
	preload("res://Recourses/PlayerSprites/Climber1.tres"),
	preload("res://Recourses/PlayerSprites/Climber2.tres"),
	]

var all_player_abilitys = {
	"Glide" = preload("res://Scripts/Player/Abilitys/glide.gd"),
	"Sky_Lift_Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Climbers_Hook" = preload("res://Scripts/Player/Abilitys/climbers_hook.gd"), 
	"Drum_Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd")
}

var goal_position_y : float

var max_abilitys = 3

var player_abilitys = []

signal winner (name)

signal reset

signal left_lobby

signal paused
