extends Node2D

@export var height_difference = 10 ## Height is measured in platforms

@export var visible_nodes = [] ## Will hold and send the tilemaps which form this level

var level_selected = 0

func _ready():
	level_selected = 3 #randi_range(0, get_child_count() - 2)
	
	await get_tree().create_timer(0.1).timeout
	
	for i in get_children():
		if i.get_index() < get_child_count() -1:
			i.visible = false
	
	get_child(level_selected).visible = true
	
	for i in get_children():
		if i.get_index() != level_selected:
			i.queue_free()
