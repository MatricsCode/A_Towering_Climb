extends MultiplayerSpawner

@export var player_scene: PackedScene

var players = {}

func _ready():
	GlobalScript.start.connect(spawn_players)

func spawn_players(data):
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)
	
	await get_tree().create_timer(0.2).timeout

func spawn_player(data):
	var p = player_scene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	p.position.y -= 100
	
	p.ID = GlobalScript.peer_ID
	
	return p
func remove_player(data):
	players[data].queue_free()
	players.erase(data)
