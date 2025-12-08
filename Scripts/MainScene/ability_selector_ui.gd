extends Control

func _ready():
	for i in GlobalScript.all_player_abilitys.keys():
		var button = Base_Button.new()
		button.name = i
		button.text = i
		button.parent = self
		get_child(0).add_child(button)
	
	var button = Base_Button.new()
	button.name = "Back"
	button.text = "Back"
	button.parent = self
	get_child(0).add_child(button)

func button_pressed(ability_button):
#region Back
	
	if ability_button == "Back":
		visible = false
		$"../SelectorUI".visible = true
		return
	
#endregion
	
#region Main
	
	var useless_array = []
	useless_array.append(ability_button)
	
	if GlobalScript.player_abilitys.is_empty():
		GlobalScript.player_abilitys.append(ability_button)
		return
	
	else:
		for i in GlobalScript.player_abilitys:
			if i == ability_button:
				GlobalScript.player_abilitys.erase(ability_button)
				print("Did exist")
				return
			else:
				pass
		print("Didn't exist")
		GlobalScript.player_abilitys.append(ability_button)
#endregion
