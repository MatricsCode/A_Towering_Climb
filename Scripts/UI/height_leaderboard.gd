extends Control

var children = []

var themes = [
	preload("res://Recourses/PlayerSprites/PlayerHeadSprites/Climber1 HeightLeaderboard.tres"),
	preload("res://Recourses/PlayerSprites/PlayerHeadSprites/Climber2 HeightLeaderboard.tres"),]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_child_count() > GlobalScript.player_positions_y.size():
		get_child(get_child_count() - 1).queue_free()
	
	for i in GlobalScript.player_positions_y.size():
		if get_child_count() < GlobalScript.player_positions_y.size():
			var height_representor = VSlider.new()
			add_child(height_representor)
			height_representor.step = 0.01
			height_representor.editable = false
			height_representor.tick_count = 5
			height_representor.theme = themes[0]
			height_representor.max_value = -1 * (GlobalScript.goal_position_y - 50)
			height_representor.min_value = 0
			
			children.append(height_representor)
		
		children.get(i).value = GlobalScript.player_positions_y[i] * -1
		
		if saved_switch_themes > 0:
			switch_costume()
			saved_switch_themes -= 1

var current_child = 0

var current_theme = 0

var saved_switch_themes = 0

func switch_costume():
	if get_child_count() != 0:
		if get_child_count() - 1 == current_child:
			current_theme += 1
			
			get_child(get_child_count() - 1).theme = themes[current_theme]
		
		else:
			current_child = get_child_count() - 1
			
			current_theme = 1
			
			children.get(get_child_count() - 1).theme = themes[current_theme]
	else:
		saved_switch_themes += 1
