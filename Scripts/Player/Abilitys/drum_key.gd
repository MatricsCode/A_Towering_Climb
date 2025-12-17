extends abilitys

func _physics_process(delta):
	if in_action == true:
		player.velocity.x = 0
		
		var direction = Input.get_axis("Left", "Right")
		player.position.x += 0.5 * direction
		if direction != 0:
			$"../../Sprite".play("walk")
		else:
			$"../../Sprite".play("idle")
		
		if direction > 0:
			$"../../Sprite".flip_h = false
		elif direction < 0:
			$"../../Sprite".flip_h = true
		
		player.main_vars.gravity = 1
