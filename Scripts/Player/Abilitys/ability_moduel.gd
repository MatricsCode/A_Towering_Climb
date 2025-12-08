extends Node

class_name abilitys

@export var activation_state = 0
@export var player : CharacterBody2D

var in_action = false


func overide():
	in_action = true
	get_parent().get_parent().overide(true)

func reset():
	in_action = false
	get_parent().get_parent().overide(false)
