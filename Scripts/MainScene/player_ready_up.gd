extends MultiplayerSpawner

@onready var background = $"../Background"

const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")
var players = []

var everyone_readyed = []

var host = false

var index = 5629

func _ready():
	spawn_function = spawn_player_selector
	
	multiplayer.peer_connected.connect(spawn)
	multiplayer.peer_disconnected.connect(despawn_player_selector)

func start():
	background.visible = true
	
	spawn(Steam.getSteamID())
func reset():
	background.visible = false
	
	for i in get_children():
		if i.get_index() > 1:
			i.queue_free()

func _physics_process(delta):
	if Input.is_action_just_pressed("Dev"):
		spawn(index + randi_range(10, 50))

func ready(readied : bool, index : int):
	#everyone_readyed[index] = readied
	#
	if readied:
		for i in get_child(0).get_children():
			i.queue_free()
			everyone_readyed.clear()
			players.clear()
			get_parent().start()

func spawn_player_selector(data):
	var play_select = PLAYER_SELECTOR.instantiate()
	
	players.append(data)
	
	play_select.main_player = data
	
	play_select.main_screen = $"."
	
	play_select.position = Vector2(70 + 220 * (data -1), -2101.0)
	everyone_readyed.append(false)
	
	play_select.name = "Player"
	
	return play_select
func despawn_player_selector(data):
	players.erase(data)
