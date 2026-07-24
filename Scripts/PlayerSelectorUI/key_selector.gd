extends VBoxContainer

@onready var control = $"."

@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators
@onready var vitaliser = $"../Vitaliser"

var abilities = {}

func _ready():
	for i in indicators.get_children():
		i.color = control.red
	
	buttons.get_child(0).grab_focus()
	
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			for y in buttons.get_children():
				if y.text == "":
					y.text = str(InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", ""), " Key")
					y.name = InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")
					break
	
	for i in $"../Vitaliser".abilities.keys():
		for y in buttons.get_children():
			if y.name == i:
				indicators.get_child(y.get_index()).color = control.green

func button_pressed(data):
	for i in buttons.get_children():
		if i.name == data:
			indicators.get_child(i.get_index()).color = control.green
	
	vitaliser.current_button = data
	visible = false
	vitaliser.visible = true

func check(abilities : Dictionary):
	print(abilities)
	for i in indicators.get_children():
		i.color = control.red
		for y in abilities.keys():
			if buttons.get_child(i.get_index()).name == y:
				i.color = control.green
