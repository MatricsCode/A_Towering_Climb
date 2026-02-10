extends MultiplayerSpawner

@export var player_scene: PackedScene

var players = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.reset.connect(_reset)
	
	print("You are appending the players position to a global array in multiplayer_spawner.gd")
	
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)

func spawn_player(data):
	var p = player_scene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	p.position.y -= 100
	
	p.player = data
	
	return p
func remove_player(data):
	players[data].queue_free()
	players.erase(data)

func _physics_process(_delta):
	for i in get_children():
		if GlobalScript.player_positions_y.size() == get_child_count():
			GlobalScript.player_positions_y.set(i.get_index(), i.position.y)
		else:
			if GlobalScript.player_positions_y.size() < get_child_count():
				GlobalScript.player_positions_y.append(i.position.y)
			else:
				GlobalScript.player_positions_y.erase(GlobalScript.player_positions_y.size())

func _reset():
	for i in get_child_count():
		get_child(i).position.x = i * -50
		get_child(i).position.y = -100
