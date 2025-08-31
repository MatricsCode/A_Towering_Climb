extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused == true:
		visible = true
		$VBoxContainer/UpPause.disabled = true
	else:
		$VBoxContainer/UpPause.disabled = false
		visible = false

func _on_button_pressed():
	get_tree().paused = false
