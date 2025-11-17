extends Control

func _ready():
	for i in get_child_count(true):
		var child = get_child(i)
		if child.name != "WinMenu":
			child.visible = true
		else:
			child.visible = false
