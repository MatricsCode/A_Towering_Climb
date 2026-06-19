extends Node

var player_ID = 0
var countdown_timer = 5

var important_positions = {}
var max_abilitys = 3

var all_player_abilitys = {
	"Glide" = preload("res://Scripts/Player/Abilitys/glide.gd"),
	"Sky_Lift_Key" = preload("res://Scripts/Player/Abilitys/skylift_key.gd"),
	"Climbers_Hook" = preload("res://Scripts/Player/Abilitys/climbers_hook.gd"), 
	"Drum_Key" = preload("res://Scripts/Player/Abilitys/drum_key.gd"),
	"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd"),
	"Sandwich" = preload("res://Scripts/Player/Abilitys/sandwich.gd"),
	"Can_Opener" = preload("res://Scripts/Player/Abilitys/bean_opener.gd"),
}

## It is {"ID" : {"Position" : Vector2, "Costume" : 0, "Abilities" : []}}
var player_attributes = {}

signal projectile (type)

signal winner (name)
signal reset
signal left_lobby
signal paused
signal start

func reset_now():
	player_attributes.clear()
