extends Node

@export var player_outfits : Array[int]

var all_player_outfits = [
	preload("res://Recourses/PlayerSprites/Climber1.tres"),
	preload("res://Recourses/PlayerSprites/Climber2.tres"),
	preload("res://Recourses/PlayerSprites/Baker.tres"),
]
var all_player_abilitys = {
	"Glide" = preload("res://Scripts/Player/Abilitys/glide.gd"),
	"Sky_Lift_Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Climbers_Hook" = preload("res://Scripts/Player/Abilitys/climbers_hook.gd"), 
	"Drum_Key" = preload("res://Scripts/Player/Abilitys/ability_moduel.gd"),
	"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd"),
	"Sandwich" = preload("res://Scripts/Player/Abilitys/sandwich.gd"),
}

var all_projectiles = {
	"Sandwich" = preload("res://Scenes/Sandwich.tscn"),
}

var important_positions = { }
var max_abilitys = 3

var player_abilitys = ["Glide", "Sky_Lift_Key", "Sandwich"]

var player_positions_y : Array[float]

signal projectile (type)

signal winner (name)
signal reset
signal left_lobby
signal paused

func reset_now():
	player_abilitys = [""]
