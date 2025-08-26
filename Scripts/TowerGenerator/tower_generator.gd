extends Node2D

@export var height_difference = 10 ## Height is measured in platforms

@export var visible_nodes = [] ## Will hold and send the tilemaps which form this level

func _ready():
	await get_tree().create_timer(0.5).timeout
	if visible_nodes == []: ## Checks if is the host
		for i in get_children(false):
			
			if i.get_index() == get_child_count() - 1: ## Sees if the child currently sellecting is MultiplayerSync
				return
			
			var chosen_child = randi_range(1, i.get_child_count()) ## Holds the current tilemap to be turned on
			
			for y in i.get_children(false):
				if y.get_index() != chosen_child - 1:
					y.queue_free()
			
			i.get_child(chosen_child - 1).visible = true ## Turns on the correct tilemap
			
			visible_nodes.append(chosen_child) ## Adds the current tilemap to the array
			i.position.y = -(height_difference * i.get_index() * 80) ## Displaces all of the tilemaps into a tower
	else:
		for i in get_children(false):
			
			print(visible_nodes)
			
			if i.get_index() == get_child_count() - 1: ## Sees if the child currently sellecting is MultiplayerSync
				return
			
			var chosen_child = visible_nodes[i.get_index(false) -1] ## Takes the current tilemap out of the array
			
			for y in i.get_children(false):
				if y.get_index() != chosen_child:
					y.queue_free()
				else:
					y.visible = true ## Turns on the correct tilemap
			
			i.position.y = -(height_difference * i.get_index() * 80) ## Displaces all of the tilemaps into a tower
