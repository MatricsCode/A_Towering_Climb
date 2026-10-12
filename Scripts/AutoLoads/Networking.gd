extends Node

const LOBBY_TYPE := Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY
const MAX_PLAYERS := 4

var current_lobby

var peer : MultiplayerPeer

func _ready():
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)

func _physics_process(_delta):
	Steam.run_callbacks()

func _host_lobby():
	Steam.createLobby(LOBBY_TYPE, MAX_PLAYERS)

func _on_lobby_created(connected : int, _lobby_id : int) -> void:
	if connected == Steam.RESULT_OK:
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		multiplayer.multiplayer_peer = peer
		Signals.host_created.emit()
func _on_lobby_joined(lobby_id : int, _permissions : int, _locked : bool, response : int) -> void:
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		if Steam.getLobbyOwner(lobby_id) == Steam.getSteamID():
			return
		peer.multiplayer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client()
		multiplayer.multiplayer_peer = peer
		Signals.lobby_joined.emit()
func _on_join_request(lobby_id : int, _steam_id : int) -> void:
	Steam.joinLobby(lobby_id)
