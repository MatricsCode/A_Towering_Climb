extends MultiplayerSpawner

@export var level_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)

func spawn_player(data):
	var p = level_scene.instantiate()
	return p
