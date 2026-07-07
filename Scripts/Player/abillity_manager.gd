extends Node

@export var main_player : CharacterBody2D

var inputs = {
	"Ability1" = false,
	"Ability2" = false,
	"Ability3" = false}

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	#if "Sky_Lift_Key" in GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities").values():
		#inputs["Ability1"] = true
	#elif "Drum_Key" in GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities").values():
		#inputs["Ability1"] = true
	#elif "Bean_Opener" in GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities").values():
		#inputs["Ability1"] = true
	
	var ability_dict = GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities")
	
	for i in ability_dict.keys():
		var ability = ability_dict[i]
		ability.set_script(GlobalScript.all_player_abilitys.get(i, null))
		ability.name = i
		ability.player = main_player
		#for y in GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities").keys():
			#if GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Abilities")[y] = 
		
		ability.input = i
		
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
