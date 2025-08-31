extends Control

var children = []

var slider_theme = preload("res://Recourses/Height Leaderboard.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_child_count() > GlobalScript.player_positions_y.size():
		get_child(get_child_count() - 1).queue_free()
	
	for i in GlobalScript.player_positions_y.size():
		if get_child_count() < GlobalScript.player_positions_y.size():
			var height_representor = VSlider.new()
			add_child(height_representor)
			height_representor.step = 0.01
			height_representor.editable = false
			height_representor.theme = slider_theme
			height_representor.max_value = 5250.0
			height_representor.min_value = 0
			children.append(height_representor)
		
		children.get(i).value = GlobalScript.player_positions_y[i] * -1
