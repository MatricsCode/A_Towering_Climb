extends Panel

@export var host_button : HoverButton
@export var join_button : HoverButton
@export var quit_button : HoverButton

@export var reload_lobbies_button : HoverButton

@export var id_button : HoverButton
@export var lobby_input_field : LineEdit

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
	
	id_button.pressed.connect(func(): lobby_input_field.clear())
	reload_lobbies_button.pressed.connect(func() : Signals.request_lobby_list.emit())
	
	lobby_input_field.text_changed.connect(_search_request)
	
	Signals.lobby_match_list.connect(_lobby_match_list)

func _host_pressed():
	Networking._host_lobby()
func _join_pressed():
	pass
func _quit_pressed():
	get_tree().quit()
func _join_lobby_button_pressed(lobby_id : String):
	var int_lobby_id := int(lobby_id)
	Steam.joinLobby(int_lobby_id)

func _lobby_match_list(lobbies : Array):
	for i in lobby_list.get_children():
		i._remove()
	
	for lobby in lobbies:
		var button = HoverButton.new()
		
		button.name = str(lobby)
		button.text = str(Steam.getLobbyData(lobby, "name"))
		button.return_name = true
		
		button.returning_name.connect(_join_lobby_button_pressed)
		
		lobby_list.add_child(button)
		
		button.visible = false

func _search_request(new_text : String):
	var is_id = new_text.substr(0,1)
	var lobby_id = new_text.substr(3,-1)
	
	if id_button.button_pressed:
		for button in lobby_list.get_children():
			if button.name.find(lobby_id) != -1 and lobby_id != null:
				button.visible = true
			else:
				button.visible = false
	
	else:
		for button in lobby_list.get_children():
			if button.text.find(lobby_id) != -1:
				button.visible = true
			else:
				button.visible = false
