extends Control

func _ready():
	for i in get_child_count(true):
		var child = get_child(i)
		child.visible = true


func _on_leave_lobby_pressed():
	get_tree().paused = false
	GlobalScript.left_lobby.emit()
