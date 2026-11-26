extends Interactable

func _interactable_ready():
	area.set_collision_layer_value(1,false)

func _player_entered(player : Player):
	effects.get(_check_abilities(player)).set_process_mode(PROCESS_MODE_INHERIT)

func _turn_invisible():
	area.set_collision_mask_value(1,false)
	visible = false
