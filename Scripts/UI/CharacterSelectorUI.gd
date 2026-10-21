extends Panel

const PLAYER_SELECTOR_TEST = preload("uid://coyb4dm7dvh0w")

@export var ready_button : HoverButton
@export var lobby_text : LineEdit
@export var player_prefab : PlayerSource
@export var player_selectors : HBoxContainer

var host := false

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
	
	ready_button.pressed.connect(func():
		printerr("It works")
		
		if Steam.getLobbyOwner(Networking.current_lobby) == Steam.getSteamID():
			_start.rpc())
	
	for i in 4:
		_add_player()

func _add_player(index = -1):
	var player_selector = PLAYER_SELECTOR_TEST.instantiate()
	
	player_selector.start.connect(func():
		_start.rpc())
	player_selector.loaded.connect(func():
		lobby_text.visible = false)
	player_selector.remove.connect(func():
		_add_player(player_selector.get_index()))
	
	player_selectors.add_child(player_selector)
	if index != -1:
		player_selectors.move_child(player_selector, index)

	#var loaded_player_selectors := 0
	#
	#for i in player_selectors.get_children():
		#if i.has_loaded:
			#loaded_player_selectors += 1
	#
	#if loaded_player_selectors < 4:
		#var player_selector = PLAYER_SELECTOR_TEST.instantiate()
		#player_selector.start.connect(func():
			#if Steam.getLobbyOwner(Networking.current_lobby) == Steam.getSteamID():
				#lobby_text.visible = false
				#_start.rpc())
		#player_selector.loaded.connect(func():
			#_add_player())
		#player_selector.remove.connect(func():
			#if loaded_player_selectors == 4:
				#_add_player())
		#player_selectors.add_child(player_selector)

@rpc("authority", "call_local", "reliable")
func _sending_player_prefab(prefab : PlayerSource):
	GlobalScript.player_prefabs.append(prefab)

@rpc("authority", "call_local", "reliable")
func _start():
	Signals.lobby_start_game.emit()
