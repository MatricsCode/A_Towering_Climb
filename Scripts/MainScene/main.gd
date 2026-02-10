extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner
@onready var lobbies = $SelectorUI/HSplitContainer/LobbyContainer/Lobbies

@onready var MainUI = $SelectorUI
@onready var PlayerReadyScreen = $PlayerReadyScreen
@onready var AbilitySelectorUI = $"AbilitySelector UI"

@onready var host = $SelectorUI/HSplitContainer/VBoxContainer/Host
@onready var refresh = $SelectorUI/HSplitContainer/VBoxContainer/Refresh

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.left_lobby.connect(leave_lobby)
	
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(on_lobby_created)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	open_lobby_list()

var time = 0
func _physics_process(delta):
	if lobby_id == 0:
		position.x += 1
		time += 0.1
		position.y = sin(time) * 2

func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func _on_host_pressed():
	#if peer.get_lobby_id() == 0:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	
	multiplayer.multiplayer_peer = peer
	
	for i in peer.get_peer_map().size() + 1:
		GlobalScript.player_outfits.append(0)
	
	PlayerReadyScreen.start()
	PlayerReadyScreen.host = true
	MainUI.hide()
func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	
	PlayerReadyScreen.start()
	MainUI.hide()

func on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id,"name",str(Steam.getPersonaName()+"'s lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
func on_lobby_match_list(lobbies2):
	for lobby in lobbies2:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var lobby_mem = Steam.getNumLobbyMembers(lobby)
		
		var but = Button.new()
		but.set_text(str(lobby_name ," | Playercount :", lobby_mem))
		but.set_size(Vector2(100, 5))
		but.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		lobbies.add_child(but)

func _on_refresh_pressed():
	if lobbies.get_child_count():
		for i in lobbies.get_children():
			i.queue_free()
	open_lobby_list()

func leave_lobby():
	if lobby_id != 0:
		Steam.leaveLobby(lobby_id)
		
		lobby_id = 0
	for i in GlobalScript.player_outfits:
		GlobalScript.player_outfits.erase(i)
	
	var lobby_members = peer.get_peer_map()
	
	var IDs = lobby_members.keys()
	
	for i in IDs.size():
		Steam.closeP2PSessionWithUser(IDs[i])
	
	Steam.leaveLobby(peer.get_lobby_id())
	peer.set_lobby_data("ID", "0")
	
	peer.close()
	get_child(get_child_count() - 1).queue_free()
	MainUI.show()
	PlayerReadyScreen.reset()
	$SelectorUI/Camera2D.enabled = true

func _on_abilitys_pressed():
	MainUI.visible = false
	AbilitySelectorUI.visible = true


func _on_ready_pressed():
	ms.spawn("res://Scenes/PlayArea.tscn")
	$SelectorUI/Camera2D.enabled = false
	PlayerReadyScreen.reset()
