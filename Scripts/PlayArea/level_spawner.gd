extends MultiplayerSpawner

@export var current_level = 0

var levels = [preload("res://Scenes/Levels/level_1.tscn"), preload("res://Scenes/Levels/level_2.tscn")]

var level_scene
var previouse_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = choose_level()
	
	level_scene = levels[current_level]
	
	spawn_function = spawn_level
	
	if is_multiplayer_authority():
		spawn()
  
func spawn_level(_data):
	var p = level_scene.instantiate()
	return p

func choose_level():
	var chosen_level = randi_range(0, levels.size() - 1)
	
	if chosen_level == previouse_level:
		chosen_level += 1
		if chosen_level > levels.size() -1:
			chosen_level -= 2
	
	previouse_level = chosen_level
	
	return chosen_level
