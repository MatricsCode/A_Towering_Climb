extends VBoxContainer

var current_button = null
var current_letter = null
var current_action = null

@onready var button_container = $HBoxContainer/Button_container
@onready var letter_container = $HBoxContainer/Letter_container

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_input(false)
	
	for i in InputMap.get_actions():
		
		if not i.contains("ui"):
			var text = Label.new()
			text.text = InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")
			
			text.size_flags_vertical = text.SIZE_EXPAND_FILL
			text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			letter_container.add_child(text)
			
			var button = Base_Button.new()
			
			button.func_parent = self
			button.text = str(i)
			button.name = str(i)
			
			button.size_flags_vertical = button.SIZE_EXPAND_FILL
			
			button_container.add_child(button)
	
	button_container.get_child(0).grab_focus()

func button_pressed(text):
	if current_button != null:
		return
	
	current_action = text
	var index = 0
	
	for i in button_container.get_children():
		if i.name == text:
			current_button = i
			index = current_button.get_index()
	
	current_letter = letter_container.get_child(index)
	
	set_process_unhandled_input(true)
	current_button.text = "Awaiting Input"
	current_button.release_focus()

func _unhandled_input(event):
	if event.pressed:
		set_process_unhandled_input(false)
		InputMap.action_erase_events(current_action)
		InputMap.action_add_event(current_action, event)
		current_button.text = current_action
		
		current_letter.text = InputMap.action_get_events(current_action)[0].as_text().replace(" (Physical)", "")
		current_button.grab_focus()
		
		current_button = null
		current_letter = null
		current_action = null
