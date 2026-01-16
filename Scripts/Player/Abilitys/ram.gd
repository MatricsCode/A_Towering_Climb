extends abilitys

var timer = 0

func _physics_process(delta):
	if Input.is_action_pressed("Ram") and ! in_action:
		overide()
		
		var direction = player.get_sprite_rotation()
		
		timer += 1
		
		if player.velocity.x * direction < 0:
			player.velocity.x *= direction
		
		player.velocity.x = 500 * direction
		$"../../Sprite".play("ram")
	
	if not Input.is_action_pressed("Ram") and in_action:
		player.velocity.x = 0
		reset()
	
	if player.bump_detectors.bumped() and in_action:
		player.velocity.y = timer * -75
		player.velocity.x = timer * -150 * player.get_sprite_rotation()
		reset()
		
	
