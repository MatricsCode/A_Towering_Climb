extends Node

const LOBBY_TYPE := Steam.LobbyType.LOBBY_TYPE_PUBLIC
const MAX_PLAYERS := 4

var current_lobby : int

var peer : MultiplayerPeer

var host := false

func _ready():
	Signals.request_lobby_list.connect(_request_lobby_list)
	Signals.lobby_start_game.connect(func(): Steam.setLobbyJoinable(current_lobby, false))
	Signals.readied_peer.connect(_check_peers)
	
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)
	Steam.lobby_match_list.connect(func(lobbies : Array) : Signals.lobby_match_list.emit(lobbies))
	Steam.lobby_chat_update.connect(_lobby_message_recieved)
	
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
	
	elif connected == Steam.RESULT_NO_CONNECTION:
		GlobalScript.no_internet = true
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		
		
		multiplayer.multiplayer_peer = peer
		Signals.host_created.emit(lobby_id)
		current_lobby = lobby_id
		
		Signals.lobby_joined.emit(lobby_id)
		

func _on_lobby_joined(lobby_id : int, _permissions : int, _locked : bool, response : int) -> void:
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		
		Signals.lobby_joined.emit(lobby_id)
		
		if Steam.getLobbyOwner(lobby_id) != Steam.getSteamID():
			peer = SteamMultiplayerPeer.new()
			peer.server_relay = true
			multiplayer.multiplayer_peer = peer
			current_lobby = lobby_id
			
			peer.create_client(Steam.getLobbyOwner(lobby_id))
			Signals.lobby_joined.emit(lobby_id)
func _on_join_request(lobby_id : int, _steam_id : int) -> void:
	Steam.joinLobby(lobby_id)

func _request_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func _check_peers(ID):
	if host:
		Steam.getLobbyData(current_lobby, "peers")


func _lobby_message_recieved(lobby_id: int, changed_id: int, making_change_id: int, chat_state: int):
	if chat_state == Steam.ChatMemberStateChange.CHAT_MEMBER_STATE_CHANGE_ENTERED and host:
		_peer_joined.rpc(changed_id)
	elif chat_state == Steam.ChatMemberStateChange.CHAT_MEMBER_STATE_CHANGE_ENTERED and host:
		_peer_left.rpc(changed_id)

@rpc("authority", "call_local", "reliable")
func _start_game():
	Signals.lobby_start_game.emit()

@rpc("authority", "call_local", "reliable")
func _peer_joined(ID : int):
	Signals.peer_joined.emit(ID)

@rpc("authority", "call_local", "reliable")
func _peer_left(ID : int):
	Signals.peer_left.emit(ID)

@rpc("any_peer", "call_local", "reliable")
func _peer_ready(player_prefabs : Array):
	var ID = Steam.getSteamID()
	
	if player_prefabs.size() == 0:
		GlobalScript.peers_ready.erase(ID)
		Signals.peer_waiting.emit(ID)
		return
	
	GlobalScript.peers_ready.append(ID)
	GlobalScript.players[Steam.getSteamID()] = player_prefabs
	Signals.readied_peer.emit(ID)
