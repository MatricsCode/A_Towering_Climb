extends VBoxContainer

@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators
@onready var vitaliser = $"../Vitaliser"

func _ready():
	for i in indicators.get_children():
		i.color = Color.RED
	
	buttons.get_child(0).grab_focus()
	
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			for y in buttons.get_children():
				if y.text == "":
					y.text = str("Button : ", InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", ""))
					y.name = InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")
					break
	
	for i in $"../Vitaliser".abilities.keys():
		for y in buttons.get_children():
			if y.name == i:
				indicators.get_child(y.get_index()).color = Color.GREEN

func button_pressed(data):
	for i in buttons.get_children():
		if i.name == data:
			indicators.get_child(i.get_index()).color = Color.GREEN
	
	vitaliser.current_button = data
	visible = false
	vitaliser.visible = true
	$"../Vitaliser/SplitContainer/Buttons/Glide".grab_focus()
