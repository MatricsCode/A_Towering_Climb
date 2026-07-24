extends VBoxContainer

@onready var vitaliser = $"../Vitaliser"

@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators
@onready var control = $"../../.."

var abilities = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in indicators.get_children():
		i.color = control.green
	
	buttons.get_child(0).grab_focus()
	
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			buttons.get_child(0).text = str(InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", ""), " Key")
			buttons.get_child(0).name = InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")

func button_pressed(data):
	if "PassiveAbility" in data:
		vitaliser.get_child(1).visible = true
	else:
		vitaliser.get_child(0).visible = true
	
	vitaliser.current_button = data
	vitaliser.visible = true
	
	vitaliser.sort()
	
	visible = false
