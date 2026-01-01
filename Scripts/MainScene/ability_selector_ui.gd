extends Control

@onready var deselect_buttons = $HSplitContainer/Deselect_buttons
@onready var select_buttons = $HSplitContainer/Select_buttons

func _ready():
	for i in GlobalScript.all_player_abilitys.keys():
		select_buttons.add_child(create_button(i, i))
	
	
	select_buttons.add_child(create_button("Back", "Back"))
	deselect_buttons.add_child(create_button("Back", "Back"))

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
		var count1 = 0
		for i in GlobalScript.player_abilitys:
			if i == ability_button:
				GlobalScript.player_abilitys.erase(ability_button)
				print("Did exist")
			else:
				count1 += 1
		if count1 == GlobalScript.player_abilitys.size():
			GlobalScript.player_abilitys.append(ability_button)
	
	#endregion
	
	
	#region Buttons
	for i in deselect_buttons.get_children():
		i.queue_free()
	for i in select_buttons.get_children():
		i.queue_free()
	
	
	var other_abilitys = []
	
	var found = false
	
	for i in GlobalScript.all_player_abilitys.keys():
		
		for y in GlobalScript.player_abilitys:
			if i == y:
				found = true
				other_abilitys.append(i)
		
		if found == false:
			GlobalScript.player_abilitys.append(i)
	
	
	for i in GlobalScript.player_abilitys:
		deselect_buttons.add_child(create_button(i,i))
	
	for i in other_abilitys:
		select_buttons.add_child(create_button(i,i))
	#endregion 
	

	
	#region Test
	#for i in select_buttons.get_children():
		#i.queue_free()
	#for i in deselect_buttons.get_children():
		#i.queue_free()
	#
	#var ability_list = GlobalScript.all_player_abilitys.values()
	#
	#for i in GlobalScript.player_abilitys:
		#deselect_buttons.add_child(create_button(i, i))
	#
	#for i in GlobalScript.all_player_abilitys.values():
		#
		#var count2 = 0
		#
		#for y in GlobalScript.player_abilitys:
			#if str(i) != str(y):
				#count2 += 1
		#
		#if count2 == GlobalScript.player_abilitys.size():
			#select_buttons.add_child(create_button(str(i), str(i)))
	#
	#select_buttons.add_child(create_button("Back", "Back"))
	#deselect_buttons.add_child(create_button("Back", "Back"))
	#endregion
	

func create_button(set_name, set_text):
	var button = Base_Button.new()
	button.name = set_name
	button.text = set_text
	button.parent = self
	return button
