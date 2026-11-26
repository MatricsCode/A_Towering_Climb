extends Effect

var reset_vars : Array

func _player_entered(player : Player):
	reset_vars.assign(player.main_vars_reset)
	player.main_vars_reset[0] *= 1.5
	player.main_vars_reset[1] *= 1.5
	player.main_vars_reset[6] *= 1.5
	player._reset_main_vars()
	
	player._status_effect_update(true, preload("uid://cwwdbeturt22m"))
	interactable._turn_invisible()
	
	await get_tree().create_timer(15).timeout
	
	player.main_vars_reset.assign(reset_vars)
	player._reset_main_vars()
	
	player._status_effect_update(true)
