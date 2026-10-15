extends Panel

@export var host_button : HoverButton
@export var join_button : HoverButton
@export var quit_button : HoverButton
@export var reload_lobbies_button : HoverButton

@export var lobby_list : VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	host_button.visible = false
	join_button.visible = false
	quit_button.visible = false
	reload_lobbies_button.visible = false
	
	host_button.pressed.connect(_host_pressed)
	join_button.pressed.connect(_join_pressed)
	quit_button.pressed.connect(_quit_pressed)
	
	reload_lobbies_button.pressed.connect(func() : Signals.request_lobby_list.emit())
	
	Signals.lobby_match_list.connect(_lobby_match_list)

func _host_pressed():
	Networking._host_lobby()
func _join_pressed():
	pass
func _quit_pressed():
	get_tree().quit()

func _join_lobby_button_pressed():
	pass

func _lobby_match_list(lobbies : Array):
	for i in lobby_list.get_children():
		i._remove()
	
	for lobby in lobbies:
		var button = HoverButton.new()
		
		button.name = str(lobby)
		button.text = str(Steam.getLobbyData(lobby, "name"))
		button.pressed.connect(_join_lobby_button_pressed)
		
		lobby_list.add_child(button)
		
		button.visible = false
