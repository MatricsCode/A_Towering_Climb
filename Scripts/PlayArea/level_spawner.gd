extends MultiplayerSpawner

var levels = [preload("res://Scenes/Levels/level_1.tscn"), preload("res://Scenes/Levels/level_2.tscn")]

var level_scene
var previouse_level

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.reset.connect(_reset)
	
	level_scene = levels[choose_level()]
	
	spawn_function = spawn_player
	
	if is_multiplayer_authority():
		spawn()

func _reset():
	get_child(0).queue_free()
	
	if is_multiplayer_authority():
		level_scene = levels[choose_level()]
		spawn()
  
func spawn_player(_data):
	var p = level_scene.instantiate()
	return p

func choose_level():
	var chosen_level = randi_range(0, levels.size() - 1)
	if chosen_level == previouse_level:
		if previouse_level == 0:
			chosen_level = 1
		elif previouse_level != 0:
			chosen_level = previouse_level - 1
	previouse_level = chosen_level
	
	return chosen_level
