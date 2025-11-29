extends Node

class_name abilitys

@export var current_state = 0
@export var activation_state = 0

func overide():
	get_parent().get_parent().overide(true)

func reset():
		get_parent().get_parent().overide(false)
