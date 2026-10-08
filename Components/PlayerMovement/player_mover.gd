extends Node2D

func _overide_player_controls(player_list : Array[CharacterBody2D], new_position):
	for i in player_list:
		i.position = new_position

func _overide_player_movement(player_list : Array[CharacterBody2D], new_speed):
	for i in player_list:
		i.speed = new_speed
