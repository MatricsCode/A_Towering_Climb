extends abilitys

var flying = false
var current_speed = 0

var gravity = 100
var timer = 0

var position = Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_pressed("Ram") and player.current_state == activation_state and player.is_on_floor():
		player.set_collision_mask_value(3, false)
		flying = false
		
		player.velocity.x += 100 * player.get_sprite_rotation()
		current_speed = player.velocity.x
		
		#if player.velocity.x * direction < 0:
			#player.velocity.x *= direction
		$"../../Sprite".play("ram")
		
		overide()
	
	if Input.is_action_pressed("Ram") and in_action and !flying:
		var range
		
		range = player.position.x - position.x
		
		if range < 10 and range > -10 and player.velocity.x == 0:
			flying = true
			
			player.position.y += -50
			player.position.x += -70 * player.get_sprite_rotation()
			
			player.velocity.y = -2 * current_speed * player.get_sprite_rotation()
			player.velocity.x = 1.5 * current_speed
			
			clamp(player.velocity.y, -10000, 100000)
			clamp(player.velocity.x, -10000, 100000)
			
			print("----------------------")
			
			if player.get_sprite_rotation() == -1:
				player.sprite.flip_h = false
			else:
				player.sprite.flip_h = true
		
		var direction = player.get_sprite_rotation()
		current_speed = lerp(current_speed, 1500.0 * float(direction), 0.02)
		player.velocity.x = current_speed
		
		position = player.position
	
	if not Input.is_action_pressed("Ram") and in_action and !flying:
		reset()
		timer = 0
		player.velocity.x = 0
		player.set_collision_mask_value(3, true)
	
	elif not player.is_on_floor() and in_action and !flying:
		reset()
		timer = 0
		player.set_collision_mask_value(3, true)
	
	if flying:
		fly()
		timer += 0.1
		if player.velocity.x != -1.5 * current_speed:
			player.velocity.x = -1.5 * current_speed

func fly():
	if player.velocity.y < player.MAX_GRAVITY: # Checks and adjusts the current gravity
			player.velocity.y += gravity
			gravity += 10
	
	if player.velocity.y > -500 and player.velocity.y < 0:
			player.velocity.y = 100 
	
	if player.velocity.x != -1.5 * current_speed:
		player.velocity.x = -1.5 * current_speed
	
	if player.is_on_floor() and timer > 1:
		gravity = 100
		timer = 0
		flying = false
		current_speed = player.velocity.x
	
	position = player.position
