extends VBoxContainer

@onready var control = $"../../.."
@onready var key_selector = $"../Key Selector"
@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators

var current_button = ""
var abilities = {"E" : "Glide", "Q" : "Sky_Lift_Key", "Shift" : "Climbers_Hook"}

func _ready():
	for i in indicators.get_children():
		if i.get_index() > 2:
			i.color = Color.RED
		else:
			i.color = Color.GREEN
	
	control.abilities = abilities


func button_pressed(data):
	if abilities.values().find(data) != -1:
		return
	
	abilities[current_button] = data
	
	visible = false
	key_selector.visible = true
	$"../Key Selector/SplitContainer/Buttons".get_child(0).grab_focus()
	activate(data)
	sort()
	
	control.abilities = abilities

func sort():
	var list = []
	for i in abilities.values():
		list.append(GlobalScript.all_player_abilitys.keys().find(i))
	
	var values = abilities.values()
	var keys = abilities.keys()
	
	if list.size() == 1:
		return
	
	for i in list.size() -1:
		if list[i] > list[i + 1]:
			var temp = values[i]
			values[i] = values[i + 1]
			values[i + 1] = temp
			
			temp = keys[i]
			keys[i] = keys[i + 1]
			keys[i + 1] = temp
			
			abilities.clear()
	
	for i in keys.size():
		abilities[keys[i]] = values[i]

func activate(button_name):
	var activated_ones = []
	
	for i in abilities.values():
		for y in indicators.get_children():
			if y.name == i:
				y.color = Color.GREEN
				activated_ones.append(y.name)
			
			elif not activated_ones.has(y.name):
				y.color = Color.RED
