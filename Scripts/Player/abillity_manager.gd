extends Node

@export var main_player : CharacterBody2D

var inputs = {
	"Ability1" = false,
	"Ability2" = false,
	"Ability3" = false}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	await get_tree().create_timer(0.1).timeout
	
	if "Sky_Lift_Key" in GlobalScript.player_abilitys:
		inputs["Ability1"] = true
	elif "Drum_Key" in GlobalScript.player_abilitys:
		inputs["Ability1"] = true
	elif "Bean_Opener" in GlobalScript.player_abilitys:
		inputs["Ability1"] = true
	
	for i in GlobalScript.player_abilitys:
		var ability = Node.new()
		ability.set_script(GlobalScript.all_player_abilitys.get(i, null))
		ability.name = i
		ability.player = main_player
		
		match i:
			"Glide":
				ability.activation_state = 1
			"Ram":
				ability.activation_state = 0
				ability.input = keys()
			"Sandwich":
				ability.activation_state = 0
				ability.input = keys()
			"Drum_Key":
				ability.input = "Ability1"
			"Sky_Lift_Key":
				ability.input = "Ability1"
			"Climbers_Hook":
				ability.input = keys()
			"Bean_Opener":
				ability.input = "Ability1"
			_:
				print("No Ability Specified!")
				ability.activation_state = -1
		
		add_child(ability)

func keys():
	for y in inputs.keys():
		if inputs[y] == false:
			inputs[y] = true
			return y
