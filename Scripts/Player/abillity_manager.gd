extends Node

@export var main_player : CharacterBody2D

var input

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			input = i
			break
	
	var ability_dict = GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities")
	
	for i in ability_dict.keys():
		var ability = abilitys.new()
		ability.set_script(GlobalScript.all_player_abilitys.get(i, null))
		ability.name = i
		ability.player = main_player
		
		match i:
			"Glide":
				ability.activation_state = 1
			"Ram":
				ability.activation_state = 0
			"Sandwich":
				ability.activation_state = 0
			"Punch":
				ability.activation_state = 0
			_:
				ability.activation_state = -1
		
		add_child(ability)
