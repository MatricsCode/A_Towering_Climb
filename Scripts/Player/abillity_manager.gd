extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GlobalScript.player_abilitys:
		var ability = Node.new()
		ability.set_script(GlobalScript.all_player_abilitys.get(i, null))
		ability.name = i
		ability.player = get_parent()
		
		match i:
			"Glide":
				ability.activation_state = 1
			"SkyLiftKey":
				ability.activation_state = -1
			"StrongShoulders":
				ability.activation_state = -1
			
			_:
				print("No Ability Specified!")
		
		add_child(ability)
