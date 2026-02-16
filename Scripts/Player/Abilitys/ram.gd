extends abilitys

var leaving = false
var current_speed = 0


func _physics_process(delta):
	if Input.is_action_pressed("Ram") and player.current_state == activation_state:
		leaving = false
		
		current_speed = player.velocity.x
		
		#if player.velocity.x * direction < 0:
			#player.velocity.x *= direction
		$"../../Sprite".play("ram")
		
		overide()
	
	if Input.is_action_pressed("Ram") and in_action:
		var direction = player.get_sprite_rotation()
		current_speed = lerp(current_speed, 1000.0 * float(direction), 0.05)
		player.velocity.x = current_speed
	
	if player.is_on_wall() and in_action:
		leaving = true
		
		player.position.y += -50
		player.position.x += -50 * player.get_sprite_rotation()
		
		player.velocity.y = -5 * current_speed
		player.velocity.x = -2 * current_speed
		
		
		reset()
	
	elif not Input.is_action_pressed("Ram") and in_action and !leaving:
		player.velocity.x = 0
		reset()
	
	if not player.is_on_floor() and in_action:
		reset()
