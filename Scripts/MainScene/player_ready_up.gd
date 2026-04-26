extends MultiplayerSpawner


@onready var background = $"../Background"
@onready var ready_button = $"../Background/Ready"

const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")
var players = []

var everyone_readyed = []

var host = false

func _ready():
	spawn_function = spawn_player_selector
	
	multiplayer.peer_connected.connect(spawn)
	multiplayer.peer_disconnected.connect(despawn_player_selector)

func _physics_process(delta):
	if Input.is_action_pressed("Dev1"):
		spawn(randi())

func start():
	background.visible = true
	
	spawn(get_parent().peer.get_unique_id())

func reset():
	background.visible = false
	
	for i in get_children():
		if i.get_index() > 1:
			i.queue_free()

func ready(readied : bool, index : int):
	everyone_readyed[index] = readied
	
	if everyone_readyed.find(false) == -1 and host:
		ready_button.disabled = false
		ready_button.text = "Ready when you are"
	
	elif everyone_readyed.find(false) == -1 and not host:
		ready_button.disabled = true
		ready_button.text = "Waiting for host"
	
	else:
		ready_button.disabled = true
		ready_button.text = "Waiting..."

func spawn_player_selector(data):
	var play_select = PLAYER_SELECTOR.instantiate()
	
	print(data)
	
	players.append(data)
	
	if players.size() == Steam.getNumLobbyMembers(get_parent().lobby_id) -1:
		play_select.main_player = true
	
	play_select.main_screen = $"."
	
	play_select.position = Vector2(70 + 220 * (data -1), -2101.0)
	
	GlobalScript.player_outfits.append(0)
	
	everyone_readyed.append(false)
	
	if get_child(0).get_child_count() == 0:
		play_select.main_player = true
	
	return play_select
func despawn_player_selector(data):
	get_child(players.find(data)).queue_free()
	
	players.erase(data)
	
	GlobalScript.player_outfits.remove_at(GlobalScript.player_outfits.size() - 1)

# Main part of the code is in the Root node, Node2D!
func _on_ready_pressed():
	for i in get_child(0).get_children():
		GlobalScript.player_outfits.set(i.get_index(), i.outfit)
		i.queue_free()
		everyone_readyed.clear()
		players.clear()
		ready_button.text = "Waiting..."
		ready_button.disabled = true
