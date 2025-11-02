extends Node2D

@export var height_difference = 10 ## Height is measured in platforms

@export var level_selected = -1

func _ready():
	
	for i in get_children():
		if i.get_index() < get_child_count() -1:
			i.visible = false
	
	get_child(level_selected).visible = true
	
	for i in get_children():
		if i.get_index() != level_selected:
			i.queue_free()
