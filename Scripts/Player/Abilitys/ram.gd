extends abilitys

var timer = 0

var leaving = false


func _physics_process(delta):
	if Input.is_action_pressed("Ram") and player.current_state == activation_state:
		leaving = false
		
		var direction = player.get_sprite_rotation()
		
		#if player.velocity.x * direction < 0:
			#player.velocity.x *= direction
		
		player.velocity.x = 500 * direction
		$"../../Sprite".play("ram")
		
		overide()
	
	if Input.is_action_pressed("Ram") and in_action and timer < 10:
		timer += 0.05
	
	if player.is_on_wall() and in_action:
		leaving = true
		
		player.position.y += -50
		player.position.x += -50 * player.get_sprite_rotation()
		
		player.velocity.y = timer * -150
		player.velocity.x = timer * -500 * player.get_sprite_rotation()
		
		timer = 0
		
		reset()
	
	elif not Input.is_action_pressed("Ram") and in_action and !leaving:
		player.velocity.x = 0
		timer = 0
		reset()
	
	if not player.is_on_floor() and in_action:
		timer = 0
		reset()
