extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		i.visible = true
