extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner
@onready var lobbies = $SelectorUI/HSplitContainer/LobbyContainer/Lobbies
@onready var MainUI = $SelectorUI
@onready var PlayerSelectorUI = $"PlayerSelector UI"

@onready var host = $SelectorUI/HSplitContainer/VBoxContainer/Host
@onready var refresh = $SelectorUI/HSplitContainer/VBoxContainer/Refresh

var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(on_lobby_created)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	open_lobby_list()

func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://Scenes/Level.tscn")
	MainUI.hide()
	$SelectorUI/Camera2D.enabled = false

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	MainUI.hide()
	$SelectorUI/Camera2D.enabled = false

func on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id,"name",str(Steam.getPersonaName()+"'s lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func on_lobby_match_list(lobbies2):
	for lobby in lobbies2:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var lobby_mem = Steam.getNumLobbyMembers(lobby)
		
		var but = Button.new()
		but.set_text(str("Other Computers Lobby | Playercount :", lobby_mem))
		but.set_size(Vector2(100, 5))
		but.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		lobbies.add_child(but)

func _on_refresh_pressed():
	if lobbies.get_child_count():
		for i in lobbies.get_children():
			i.queue_free()
	open_lobby_list()
	


func _on_player_customiser_pressed():
	MainUI.visible = false
	PlayerSelectorUI.visible = true
