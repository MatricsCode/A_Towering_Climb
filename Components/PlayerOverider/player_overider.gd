extends Node2D

func _overide_player_controls(player_list : Array[CharacterBody2D], overide : bool):
	for i in player_list:
		i.overide = overide
