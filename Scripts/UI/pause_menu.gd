extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().paused == true:
		visible = true
	else:
		visible = false


func _on_unpaused_pressed():
	get_tree().paused = false
