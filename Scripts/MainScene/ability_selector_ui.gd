extends Control

@onready var buttons = $HSplitContainer/Buttons
@onready var selected = $HSplitContainer/Selected

var selected_abilitys = []
var unselected_abilitys = []

func _ready():
	unselected_abilitys = GlobalScript.all_player_abilitys.keys()
	
	for i in unselected_abilitys:
		buttons.add_child(create_button(i, i))
		
		var selector = ColorRect.new()
		selector.color = Color.RED
		selector.size_flags_vertical = Control.SIZE_EXPAND_FILL
		selector.name = i
		selected.add_child(selector)
	
	var selector = ColorRect.new()
	selector.color = Color.TRANSPARENT
	selector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	selector.name = "nulldd"
	selected.add_child(selector)
	
	buttons.add_child(create_button("Back", "Back"))

func button_pressed(ability_button):
	#region Back
	if ability_button == "Back":
		visible = false
		$"../SelectorUI".visible = true
		return
	
	#endregion
	
	#region Main
	if GlobalScript.player_abilitys.is_empty():
		GlobalScript.player_abilitys.append(ability_button)
		for i in selected.get_children():
			if i.name == ability_button:
				i.color = Color.GREEN
	
	
	else:
		var found = false
		
		for i in GlobalScript.player_abilitys:
			if i == ability_button:
				found = true
		
		if found == true:
			GlobalScript.player_abilitys.erase(ability_button)
			for i in selected.get_children():
				if i.name == ability_button:
					i.color = Color.RED
		elif found == false and GlobalScript.player_abilitys.size() < GlobalScript.max_abilitys:
			GlobalScript.player_abilitys.append(ability_button)
			for i in selected.get_children():
				if i.name == ability_button:
					i.color = Color.GREEN
	
	
	#endregion
	
	

func create_button(set_name, set_text):
	var button = Base_Button.new()
	button.name = set_name
	button.text = set_text
	button.parent = self
	return button
