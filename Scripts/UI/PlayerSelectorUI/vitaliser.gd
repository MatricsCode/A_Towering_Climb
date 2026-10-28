extends VBoxContainer

@onready var control = $"../../.."
@onready var ability_selector = $"../Ability Selector"
@onready var passive_buttons = $passive_abilities/Buttons
@onready var passive_indicators = $passive_abilities/Indicators

var current_button = ""
var abilities = {"Glide" : "PassiveAbility1", "Drum_Key" : "PassiveAbility2", "Ram" : "E"}

func _ready():
	#for i in InputMap.get_actions():
		#if i.contains("Ability"):
			#abilities["Climbers_Hook"] = str(InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", ""))
	
	control.abilities = abilities

func button_pressed(data):
	for i in abilities.values():
		if i == current_button:
			abilities.erase(abilities.keys().get(abilities.values().find(i)))
	abilities[data] = current_button
	
	#if abilities.values().find(current_button) != -1:
		#abilities.erase(abilities.values().find(current_button))
		#abilities[data] = current_button
	#else:
		#abilities[data] = current_button
	
	#if abilities.values().find(data) != -1:
		#abilities.erase(abilities.keys().get(abilities.values().find(data)))
		#abilities[current_button] = data
	#else:
		#abilities[current_button] = data
	
	visible = false
	$key_abilities.visible = false
	$passive_abilities.visible = false
	ability_selector.visible = true
	
	$"../Ability Selector/SplitContainer/Buttons".get_child(0).grab_focus()
	#activate(data)
	
	control.abilities = abilities
#
#func sort():
	#var list = []
	#for i in abilities.values():
		#list.append(GlobalScript.all_player_abilitys.keys().find(i))
	#
	#var values = abilities.values()
	#var keys = abilities.keys()
	#
	#if list.size() == 1:
		#return
	#
	#for i in list.size() -1:
		#if list[i] > list[i + 1]:
			#var temp = values[i]
			#values[i] = values[i + 1]
			#values[i + 1] = temp
			#
			#temp = keys[i]
			#keys[i] = keys[i + 1]
			#keys[i + 1] = temp
			#
			#abilities.clear()
	#
	#for i in keys.size():
		#abilities[keys[i]] = values[i]

#func activate(button_name):
	#var activated_ones = []
	#
		#for i in abilities.keys():
			#for y in key_indicators.get_children():
				#if y.name == i:
					#y.color = Color.GREEN
					#activated_ones.append(y.name)
				#
				#elif not activated_ones.has(y.name):
					#y.color = Color.RED
	#

func sort():
	for i in passive_indicators.get_children():
		i.color = Color.hex(0x75a743)
	
	for i in passive_buttons.get_children():
		i.disabled = false
	
	var current_ability
	
	for i in abilities.values():
		if i == current_button:
			current_ability = abilities.keys().get(abilities.values().find(i))
	
	print(current_ability)
	
	for i in passive_indicators.get_children():
		for y in abilities.keys():
			if i.name == y and y != current_ability:
				i.color = Color.hex(0xa53030)
				passive_buttons.get_child(i.get_index()).disabled = true
