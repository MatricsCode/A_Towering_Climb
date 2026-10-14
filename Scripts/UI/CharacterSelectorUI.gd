extends Panel

@onready var user = $MarginContainer/VBoxContainer/User
@onready var id = $MarginContainer/VBoxContainer/ID


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.host_created.connect(func(lobby_id : int):
		user.text = "Host"
		id.text = str("Lobby ID: ", lobby_id))
	Signals.lobby_joined.connect(func(lobby_id : int):
		user.text = "Client"
		id.text = str("Lobby ID: ", lobby_id))
