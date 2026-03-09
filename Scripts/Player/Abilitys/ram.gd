extends abilitys

var flying = false
var current_speed = 0

var gravity = 100

var position = Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_pressed("Ram") and player.current_state == activation_state and player.is_on_floor():
		flying = false
		
		current_speed = player.velocity.x
		
		#if player.velocity.x * direction < 0:
			#player.velocity.x *= direction
		$"../../Sprite".play("ram")
		
		overide()
	
	if position == player.position and in_action:
		flying = true
		
		player.position.y += -50
		player.position.x += -50 * player.get_sprite_rotation()
		
		player.velocity.y = -2 * current_speed * player.get_sprite_rotation()
		player.velocity.x = -1.5 * current_speed
		
		if player.get_sprite_rotation() == -1:
			player.sprite.flip_h = false
		else:
			player.sprite.flip_h = true
	
	elif not Input.is_action_pressed("Ram") and in_action and !flying:
		reset()
		player.velocity.x = 0
	
	elif not player.is_on_floor() and in_action and !flying:
		reset()
	
	if Input.is_action_pressed("Ram") and in_action and !flying:
		var direction = player.get_sprite_rotation()
		current_speed = lerp(current_speed, 1500.0 * float(direction), 0.02)
		player.velocity.x = current_speed
		if player.velocity.x < -50 or player.velocity.x > 50:
			pass
			#position = player.position
	
	print(flying)
	
	if flying:
		fly()

func fly():
	if player.velocity.y < player.MAX_GRAVITY: # Checks and adjusts the current gravity
			player.velocity.y += gravity
			gravity += 10
	
	if player.velocity.y > -500 and player.velocity.y < 0:
			player.velocity.y = 100 
	
	await get_tree().create_timer(0.1).timeout
	
	if player.is_on_floor() or position == player.position:
		reset()
		gravity = 100
		flying = false
