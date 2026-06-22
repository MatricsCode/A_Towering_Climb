extends MultiplayerSpawner

@onready var selectors = $"../CanvasLayer/Container"
const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")
var players = []

var readied_up = {}

var host = false

var index

func _ready():
	spawn_function = spawn_player_selector
	
	multiplayer.peer_connected.connect(spawn)
	multiplayer.peer_disconnected.connect(despawn_player_selector)

func _start():
	selectors.visible = true
	$"../CanvasLayer/Background".visible = true
	
	set_multiplayer_authority(GlobalScript.peer_ID)
	
	spawn(GlobalScript.peer_ID)
func reset():
	for i in get_children():
		if i.get_index() > 1:
			i.queue_free()

func ready(readied : bool, index : int):
	if readied:
		for i in get_child(0).get_children():
			i.queue_free()
			readied_up.clear()
			players.clear()
			get_parent().start()

func spawn_player_selector(data):
	var play_select = PLAYER_SELECTOR.instantiate()
	
	players.append(data)
	
	play_select.player = data
	
	play_select.main_screen = self
	
	play_select.position = Vector2(70 + 220 * (data -1), -2101.0)
	
	play_select.name = "Player"
	
	play_select.func_parent = self
	
	return play_select
	
	readied_up[play_select.name] = false
func despawn_player_selector(data):
	players.erase(data)
	
	for i in selectors.get_children():
		if i.player == data:
			i.queue_free()


func _readied_up(_name, data):
	readied_up[_name] = data
	
	if readied_up.values().find(false) == -1:
		GlobalScript.start.emit(1)
