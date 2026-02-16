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
	"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd")
}

var goal_position : Vector2
var max_abilitys = 3

var player_abilitys = ["Glide", "Sky_Lift_Key", "Ram"]

var player_positions_y : Array[float]

signal winner (name)
signal reset
signal left_lobby
signal paused

func _physics_process(delta):
	if Input.is_action_pressed("Dev1"):
		winner.emit("Dave")

func reset_now():
	player_abilitys = [""]
