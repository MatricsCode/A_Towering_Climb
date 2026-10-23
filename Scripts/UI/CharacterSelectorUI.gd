extends Panel

const PLAYER_SELECTOR_TEST = preload("uid://coyb4dm7dvh0w")

@export var ready_button : HoverButton
@export var lobby_text : LineEdit
@export var player_prefab : PlayerSource
@export var player_selectors : HBoxContainer

var host := false

var players : Array[PlayerSource]

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.host_created.connect(func(lobby_id : int):
		await get_tree().create_timer(0.05).timeout
		lobby_text.text = str("Host of ", Steam.getLobbyData(lobby_id, "name"), " | ID: " , lobby_id)
		host = true)
	Signals.lobby_joined.connect(func(lobby_id : int):
		await get_tree().create_timer(0.05).timeout
		if !host:
			lobby_text.text =  str("Client of ", Steam.getLobbyData(lobby_id, "name"), " | ID: " , lobby_id))
	
	#ready_button.pressed.connect(func():
		#printerr("It works")
		#
		#if Steam.getLobbyOwner(Networking.current_lobby) == Steam.getSteamID():
			#_start.rpc())
	
	for i in 4:
		_add_player()

func _add_player():
	var player_selector = PLAYER_SELECTOR_TEST.instantiate()
	
	player_selector.finished.connect(func():
		_is_peer_ready())
	#player_selector.loaded.connect(func():
		#lobby_text.visible = false)
	#player_selector.remove.connect(func():
		#_everyone_ready())
	
	player_selectors.add_child(player_selector)


func _is_peer_ready():
	players.clear()
	print(players)
	
	for i in player_selectors.get_children():
		if i.loaded and !i.active:
			Networking._peer_ready.rpc([])
			return
		elif i.loaded and i.active:
			var character : PlayerSource
			character = i.selected_character
			
			players.append(character)
	print(players)
	Networking._peer_ready.rpc(players)
