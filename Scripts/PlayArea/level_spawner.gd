extends MultiplayerSpawner

var levels = [preload("res://Scenes/Levels/level_1.tscn"), preload("res://Scenes/Levels/level_2.tscn")]
var level_scene = levels[randi_range(0, levels.size() - 1)]


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.reset.connect(_reset)
	
	spawn_function = spawn_player
	if is_multiplayer_authority():
		#push_error("You have set the max level amount to 3 in TowerSpawner Located in the level Scene")
		spawn()

func spawn_player(_data):
	var p = level_scene.instantiate()
	#p.level_selected = data
	return p

func _reset():
	get_child(0).queue_free()
	if is_multiplayer_authority():
		#push_error("You have set the max level amount to 3 in TowerSpawner Located in the level Scene")
		level_scene = levels[randi_range(0, levels.size() - 1)]
		spawn()
