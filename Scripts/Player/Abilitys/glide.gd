extends abilitys

var min_gliding_speed = 500

func _physics_process(_delta):
	if Input.is_action_pressed("Jump") and player.current_state == activation_state and player.velocity.y > min_gliding_speed:
		overide()
		player.velocity.y -= min_gliding_speed
	
	elif in_action and Input.is_action_pressed("Jump") and not player.is_on_floor():
		$"../../Sprite".play("glide")
		player.main_vars.gravity += 1
		player.velocity.y += 5
		
		air_movement()
		
		turn()
	
	elif in_action:
		reset()

func air_movement():
	var direction = Input.get_axis("Left", "Right")
	var current_direction = 0
	
	
	if player.velocity.x == 0:
		current_direction = 0
	elif player.velocity.x > 0:
		current_direction = 1
	elif player.velocity.x < 0:
		current_direction = -1
	
	if direction == current_direction:
		player.velocity.x = lerp(player.velocity.x, player.main_vars.speed * direction, 0.3)
	elif direction != current_direction:
		player.velocity.x = lerp(player.velocity.x, player.main_vars.speed * direction, 0.05)

func turn():
	if player.velocity.x > 0:
		$"../../Sprite".flip_h = false
	elif player.velocity.x < 0:
		$"../../Sprite".flip_h = true
