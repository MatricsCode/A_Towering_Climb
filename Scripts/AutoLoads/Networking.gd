extends Node

const LOBBY_TYPE := Steam.LobbyType.LOBBY_TYPE_PUBLIC
const MAX_PLAYERS := 4

var current_lobby : int

var peer : MultiplayerPeer

var host := false

func _ready():
	Signals.request_lobby_list.connect(_request_lobby_list)
	Signals.lobby_start_game.connect(func(): Steam.setLobbyJoinable(current_lobby, false))
	
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)
	Steam.lobby_match_list.connect(func(lobbies : Array) : Signals.lobby_match_list.emit(lobbies))
	
	_request_lobby_list()

func _physics_process(_delta):
	Steam.run_callbacks()

func _host_lobby():
	host = true
	Steam.createLobby(LOBBY_TYPE, MAX_PLAYERS)

func _on_lobby_created(connected : int, lobby_id : int) -> void:
	if connected == Steam.RESULT_OK:
		
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		multiplayer.multiplayer_peer = peer
		Signals.host_created.emit(lobby_id)
		current_lobby = lobby_id
		
		Steam.setLobbyData(lobby_id, "name", "Kodumaster's lobby")
		Steam.setLobbyJoinable(lobby_id, true)
		
		print(Steam.getSteamID())

func _on_lobby_joined(lobby_id : int, _permissions : int, _locked : bool, response : int) -> void:
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		

		Signals.lobby_joined.emit(lobby_id)
		
		if Steam.getLobbyOwner(lobby_id) != Steam.getSteamID():
			peer = SteamMultiplayerPeer.new()
			peer.server_relay = true
			multiplayer.multiplayer_peer = peer
			Signals.host_created.emit(lobby_id)
			current_lobby = lobby_id
			
			peer.create_client(Steam.getLobbyOwner(lobby_id))
			Signals.lobby_joined.emit(lobby_id)
			
		
func _on_join_request(lobby_id : int, _steam_id : int) -> void:
	Steam.joinLobby(lobby_id)

func _request_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
