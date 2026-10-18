extends Panel

const PLAYER_SELECTOR_TEST = preload("uid://coyb4dm7dvh0w")

@export var ready_button : HoverButton
@export var lobby_text : LineEdit
@export var player_prefab : PlayerSource
@export var player_selectors : HBoxContainer

var host := false

var has_unloaded_player_selector := false

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
	_add_player()

func _add_player():
	if player_selectors.get_child_count() < 4:
		var player_selector = PLAYER_SELECTOR_TEST.instantiate()
		player_selector.remove.connect(func():
			if !has_unloaded_player_selector:
				has_unloaded_player_selector = true
			_add_player())
		player_selector.loaded.connect(func():
			_add_player())
		player_selector.start.connect(func():
			if Steam.getLobbyOwner(Networking.current_lobby) == Steam.getSteamID():
				_start.rpc())
		player_selectors.add_child(player_selector)

@rpc("authority", "call_local", "reliable")
func _sending_player_prefab(prefab : PlayerSource):
	GlobalScript.player_prefabs.append(prefab)

@rpc("authority", "call_local", "reliable")
func _start():
	Signals.lobby_start_game.emit()
