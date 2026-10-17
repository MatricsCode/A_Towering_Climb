extends Panel

@onready var user = $MarginContainer/VBoxContainer/User
@onready var id = $MarginContainer/VBoxContainer/ID

@export var ready_button : HoverButton

@export var player_prefab : PlayerSource

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.host_created.connect(func(lobby_id : int):
		user.text = "Host"
		id.text = str("Lobby ID: ", lobby_id))
	Signals.lobby_joined.connect(func(lobby_id : int):
		user.text = "Client"
		id.text = str("Lobby ID: ", lobby_id))
	
	ready_button.pressed.connect(_start)

func _start():
	Signals.lobby_start_game.emit()
	Signals.player_list.emit(player_prefab)

@rpc("authority", "call_local", "reliable")
func _sending_player_prefab(prefab : PlayerSource):
	GlobalScript.player_prefabs.append(prefab)
