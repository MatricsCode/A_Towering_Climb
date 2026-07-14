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
	
	$"../Background".visible = true
	
	set_multiplayer_authority(GlobalScript.peer_ID)
	
	if GlobalScript.peer_ID == 1:
		spawn(1)
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
	play_select.set_multiplayer_authority(data)
	
	play_select.main_screen = self
	
	play_select.position = Vector2(70 + 220 * (data -1), -2101.0)
	
	play_select.name = "Player"
	
	play_select.func_parent = self
	
	readied_up[data] = false
	
	return play_select
func despawn_player_selector(data):
	players.erase(data)
	
	for i in selectors.get_children():
		if i.player == data:
			i.queue_free()


func _readied_up(ID, data):
	readied_up[ID] = data
	
	var temp = readied_up.values()
	
	if temp.find(false) == -1:
		GlobalScript.start.emit(1)
