extends Panel

@export_category("Create/Join")
@export var host_button : HoverButton
@export var join_button : HoverButton
@export var lobby_join_id : LineEdit
@export var quit_button : HoverButton

@export_category("Lobby Search")
@export var reload_lobbies_button : HoverButton
@export var id_button : HoverButton
@export var lobby_search_field : LineEdit

@export var lobby_list : VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Dave")
	
	host_button.visible = false
	join_button.visible = false
	quit_button.visible = false
	reload_lobbies_button.visible = false
	
	lobby_join_id.pivot_offset_ratio = Vector2(0.5, 0.5)
	
	host_button.pressed.connect(_host_pressed)
	join_button.pressed.connect(_join_pressed)
	quit_button.pressed.connect(_quit_pressed)
	
	id_button.pressed.connect(func(): 
		lobby_search_field.text = ""
		_search_request(""))
	reload_lobbies_button.pressed.connect(func() : Signals.request_lobby_list.emit())
	
	lobby_search_field.text_changed.connect(_search_request)
	
	Signals.lobby_match_list.connect(_lobby_match_list)

func _host_pressed():
	Networking._host_lobby()
func _join_pressed():
	var lobby_id := lobby_join_id.text
	
	if lobby_id.is_valid_int():
		_join_lobby(lobby_id)
	else:
		var direction = randi_range(-1,1)
		while direction == 0:
			direction = randi_range(-1,1)
		
		var wiggle = get_tree().create_tween()
		wiggle.set_trans(Tween.TRANS_EXPO)
		
		lobby_join_id.editable = false
		lobby_join_id.text = "Only Numbers, no names!"
		wiggle.tween_property(lobby_join_id, "rotation_degrees", 20 * direction, 0.3)
		
		await wiggle.finished
		wiggle.kill()
		
		wiggle = get_tree().create_tween()
		wiggle.set_trans(Tween.TRANS_EXPO)
		wiggle.tween_property(lobby_join_id, "rotation_degrees", 20 * direction * -1, 0.4)
		
		await wiggle.finished
		wiggle.kill()
		
		wiggle = get_tree().create_tween()
		wiggle.set_trans(Tween.TRANS_EXPO)
		wiggle.tween_property(lobby_join_id, "rotation_degrees", 0, 0.3)
		
		await wiggle.finished
		
		lobby_join_id.editable = true
		lobby_join_id.text = ""
func _quit_pressed():
	get_tree().quit()
func _join_lobby(lobby_id : String):
	var int_lobby_id := int(lobby_id)
	Steam.joinLobby(int_lobby_id)

func _lobby_match_list(lobbies : Array):
	for i in lobby_list.get_children():
		i.queue_free()
	
	for lobby in lobbies:
		var button = HoverButton.new()
		
		button.name = str(lobby)
		button.text = str(Steam.getLobbyData(lobby, "name"))
		button.return_name = true
		
		button.returning_name.connect(_join_lobby)
		
		lobby_list.add_child(button)
		
		button.visible = false

func _search_request(new_text : String):
	#var lobby_id = new_text.substr(2,-1)
	
	if new_text == "":
		
		for i in lobby_list.get_children():
			i.visible = true
		
		return
	
	for button in lobby_list.get_children():
		if button.text.find(new_text) != -1:
			button.visible = true
		else:
			button.visible = false
	
	#for button in lobby_list.get_children():
		#if button.name.find(lobby_id) != -1 and lobby_id != null:
			#button.visible = true
		#else:
			#button.visible = false
	
	#if id_button.button_pressed:
		#for button in lobby_list.get_children():
			#if button.name.find(lobby_id) != -1 and lobby_id != null:
				#button.visible = true
			#else:
				#button.visible = false
	#
	#else:
		#for button in lobby_list.get_children():
			#if button.text.find(lobby_id) != -1:
				#button.visible = true
			#else:
				#button.visible = false
