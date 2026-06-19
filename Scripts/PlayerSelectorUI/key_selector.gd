extends VBoxContainer

@onready var buttons = $Buttons
@onready var vitaliser = $"../Vitaliser"

func _ready():
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			for y in buttons.get_children():
				if y.text == "":
					y.text = str("Button : ", InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", ""))
					y.name = InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")
					break

func button_pressed(data):
	vitaliser.current_button = data
	visible = false
	vitaliser.visible = true
