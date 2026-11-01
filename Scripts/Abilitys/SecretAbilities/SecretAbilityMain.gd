extends Ability
class_name SecretAbility

@export var abilities_required_1 : Script = null
@export var abilities_required_2 : Script = null

func _check_other_abilities():
	var combination = 0
	var combin_minimum = 0
	if abilities_required_1 == null or abilities_required_2 == null:
		combin_minimum = 1
	else:
		combin_minimum = 2
	
	for i in get_parent().get_children():
		if i.get_script() == abilities_required_1 or i.get_script() == abilities_required_2:
			combination += 1
	
	if combination >= combin_minimum:
		active = true
