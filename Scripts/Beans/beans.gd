extends Interactable

func action():
	player.main_vars.ground_vars["speed"] *= 1.2
	player.main_vars_reset[0] *= 1.2
	queue_free()
