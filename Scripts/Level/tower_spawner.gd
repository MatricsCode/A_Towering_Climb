extends MultiplayerSpawner

@export var level_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_player
	if is_multiplayer_authority():
		push_error("You have set the max level amount to 3 in TowerSpawner Located in the level Scene")
		spawn(randi_range(0, 2))

func spawn_player(data):
	var p = level_scene.instantiate()
	p.level_selected = data
	return p
