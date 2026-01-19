extends Node

@export var main_player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
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
			_:
				print("No Ability Specified!")
				ability.activation_state = -1
		
		add_child(ability)
