extends abilitys

var counter = 0

func _physics_process(delta):
	counter -= 1
	if Input.is_action_pressed("Ram") and counter <= 0 and player.current_state == activation_state:
		counter = 20
		GlobalScript.projectile.emit([GlobalScript.all_projectiles["Sandwich"], player.position, player.get_sprite_rotation()])
