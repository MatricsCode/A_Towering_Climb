extends Node

var player_positions_y : Array[float]

var player_outfits = [
	preload("res://Recourses/PlayerSprites/Climber1.tres"),
	preload("res://Recourses/PlayerSprites/Climber2.tres"),
	]

var all_player_abilitys = {
	"Glide" = preload("res://Scripts/Player/Abilitys/glide.gd"),
	"Sky Lift Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Strong Legs" = preload("res://Scripts/Player/Abilitys/strong_legs.gd"),
	"Climbers Hook" = preload("res://Scripts/Player/Abilitys/climbers_hook.gd"), 
	"Drum Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd")
}

var goal_position_y : float

var max_abilitys = 3

var player_abilitys = []

signal winner (name)

signal reset

signal left_lobby

signal paused
