extends Control

@onready var buttons = $Buttons

var selected_abilitys = []
var unselected_abilitys = []

func _ready():
	unselected_abilitys = GlobalScript.all_player_abilitys.keys()
	
	for i in unselected_abilitys:
		buttons.add_child(create_button(i, i))
	
	
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
	
	else:
		var found = false
		
		for i in GlobalScript.player_abilitys:
			if i == ability_button:
				found = true
		
		if found == true:
			GlobalScript.player_abilitys.erase(ability_button)
		else:
			GlobalScript.player_abilitys.append(ability_button)
	
	
	#endregion
	
	

func create_button(set_name, set_text):
	var button = Base_Button.new()
	button.name = set_name
	button.text = set_text
	button.parent = self
	return button
