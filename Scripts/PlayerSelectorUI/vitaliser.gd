extends VBoxContainer

@onready var control = $"../../.."
@onready var key_selector = $"../Key Selector"
@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators

var current_button = ""
var abilities = {}

func button_pressed(data):
	abilities[current_button] = data
	
	visible = false
	key_selector.visible = true
	
	sort()

func sort():
	var list = []
	for i in abilities.values():
		list.append(GlobalScript.all_player_abilitys.keys().find(i))
	
	var values = abilities.values()
	var keys = abilities.keys()
	
	if list.size() == 1:
		return
	
	print(values)
	
	for i in list.size() -1:
		if list[i] < list[i + 1]:
			var temp = values[i]
			values[i] = values[i + 1]
			values[i + 1] = temp
			
			temp = keys[i]
			keys[i] = keys[i + 1]
			keys[i + 1] = temp
			
			abilities.clear()
	
	print(values)
	
	for i in keys.size():
		abilities[keys[i]] = values[i]
