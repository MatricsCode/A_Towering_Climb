extends Node

const LOBBY_TYPE := Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY
const MAX_PLAYERS := 4

var current_lobby

var peer : MultiplayerPeer

func _ready():
	Signals.request_lobby_list.connect(_request_lobby_list)
	
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)
	Steam.lobby_match_list.connect(func(lobbies : Array) : Signals.lobby_match_list.emit(lobbies))
	
	_request_lobby_list()

func _physics_process(_delta):
	Steam.run_callbacks()

func _host_lobby():
	Steam.createLobby(LOBBY_TYPE, MAX_PLAYERS)

func _on_lobby_created(connected : int, lobby_id : int) -> void:
	if connected == Steam.RESULT_OK:
		Signals.lobby_joined.emit(lobby_id)
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		multiplayer.multiplayer_peer = peer
		Signals.host_created.emit(lobby_id)
		print(Steam.getPersonaName())
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName(), "'s lobby"))
func _on_lobby_joined(lobby_id : int, _permissions : int, _locked : bool, response : int) -> void:
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		if Steam.getLobbyOwner(lobby_id) == Steam.getSteamID():
			return
		Signals.lobby_joined.emit(lobby_id)
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client(Steam.getLobbyOwner(lobby_id))
		multiplayer.multiplayer_peer = peer
		Signals.lobby_joined.emit(lobby_id)
func _on_join_request(lobby_id : int, _steam_id : int) -> void:
	Steam.joinLobby(lobby_id)

func _request_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
