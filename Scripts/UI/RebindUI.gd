extends MarginContainer

@export var settings_UI : Control

@export_category("Nodes")
@export var button_container : VBoxContainer
@export var accept_button : HoverButton
@export var cancel_button : HoverButton
@export var action_label : Label
@export var event_label : Label
@export var finished_button : HoverButton

var current_action : String = ""
var current_event

func _ready():
	accept_button.pressed.connect(_change_action)
	cancel_button.pressed.connect(_finish_action)
	finished_button.pressed.connect(func():
		_finish_action()
		settings_UI._settings(true))
	
	for action in InputMap.get_actions():
		action = str(action)
		
		var info = _check_actions(action)
		if info[0]:
			var button = HoverButton.new()
			
			button.text = str(action)
			button.name = str(action)
			
			button.set_focus_neighbor(SIDE_RIGHT, accept_button.get_path())
			button.set_focus_neighbor(SIDE_LEFT, accept_button.get_path())
			
			button.pressed.connect(func():
				var change_action = button.name
				_select_action(change_action))
			
			button_container.add_child(button)
			button.visible = false
	
	accept_button.set_focus_neighbor(SIDE_LEFT, button_container.get_child(0).get_path())
	accept_button.set_focus_neighbor(SIDE_RIGHT, 
		button_container.get_child(button_container.get_child_count()-1).get_path())
	cancel_button.set_focus_neighbor(SIDE_LEFT, button_container.get_child(0).get_path())
	cancel_button.set_focus_neighbor(SIDE_RIGHT, 
		button_container.get_child(button_container.get_child_count()-1).get_path())
	
	button_container.get_child(0).grab_focus()
	finished_button.pressed.connect(func():
		pass)

func _check_actions(action : String):
	var found = false
	var player_control = 0
	
	for i in 3:
		if action.contains("P%s_"%[(i+1)]):
			player_control = i+1
			found = true
	
	return [found, player_control]
func _select_action(action : String):
	var event_text = InputMap.action_get_events(action)
	current_action = action
	current_event = event_text[0]
	event_text = str(event_text.get(0))
	
	event_text = event_text.split("(")
	event_text = event_text.get(1).split(")")
	event_text = event_text[0]
	
	action = action.get_slice("_",1)
	
	action_label.text = "Remap %s to" %[action]
	event_label.text = event_text
	
	for i in button_container.get_children():
		i.disabled = true
	accept_button.grab_focus()
func _change_action():
	if current_action == "":
		return
	InputMap.action_erase_event(current_action, InputMap.action_get_events(current_action)[0])
	InputMap.action_add_event(current_action, current_event)
	_finish_action()
func _finish_action():
	for i in button_container.get_children():
		i.disabled = false
	
	button_container.get_child(0).grab_focus()
	
	action_label.text = "Nothing Selected"
	event_label.text = ""
	current_action = ""
	current_event = null

func _input(event):
	if current_action != "":
		if str(event).find("Key") == -1 && str(event).find("JoypadMotion") == -1:
			return
		
		current_event = event
		
		var event_text = event
		event_text = str(event_text)
		
		event_text = event_text.split("(")
		event_text = event_text.get(1).split(")")
		event_text = event_text[0]
		
		event_label.text = event_text
