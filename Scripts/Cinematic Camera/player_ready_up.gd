extends MultiplayerSpawner

@onready var selectors = $"../Container"
const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")
var players = []

var everyone_readyed = []

var host = false

var index

func _ready():
	spawn_function = spawn_player_selector
	
	multiplayer.peer_connected.connect(spawn)
	multiplayer.peer_disconnected.connect(despawn_player_selector)

func start():
	selectors.visible = true
	
	spawn(Steam.getSteamID())
func reset():
	for i in get_children():
		if i.get_index() > 1:
			i.queue_free()

func ready(readied : bool, index : int):
	if readied:
		for i in get_child(0).get_children():
			i.queue_free()
			everyone_readyed.clear()
			players.clear()
			get_parent().start()

func spawn_player_selector(data):
	var play_select = PLAYER_SELECTOR.instantiate()
	
	players.append(data)
	
	play_select.player = data
	
	play_select.main_screen = self
	
	play_select.position = Vector2(70 + 220 * (data -1), -2101.0)
	everyone_readyed.append(false)
	
	play_select.name = "Player"
	
	return play_select
func despawn_player_selector(data):
	players.erase(data)
