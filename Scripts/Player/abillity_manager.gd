extends Node

@export var main_player : CharacterBody2D

var inputs = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	for i in InputMap.get_actions():
		if i.contains("Ability"):
			inputs[InputMap.action_get_events(i)[0].as_text().replace(" (Physical)", "")] = i
	
	var ability_dict = GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities")
	
	for i in ability_dict.keys():
		var ability = abilitys.new()
		ability.set_script(GlobalScript.all_player_abilitys.get(ability_dict[i], null))
		ability.name = ability_dict[i]
		ability.player = main_player
		
		ability.input = inputs[i]
		
		match i:
			"Glide":
				ability.activation_state = 1
			"Ram":
				ability.activation_state = 0
			"Sandwich":
				ability.activation_state = 0
			_:
				print("No Ability Specified!")
				ability.activation_state = -1
		
		add_child(ability)
	

func keys():
	for y in inputs.keys():
		if inputs[y] == false:
			inputs[y] = true
			return y
