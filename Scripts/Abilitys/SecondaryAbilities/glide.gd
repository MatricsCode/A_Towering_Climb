extends Ability

var min_gliding_speed = 500

func _ready():
	activation_state = player.States.AIR
	
	detectors.on_ground.connect(func(is_true : bool):
		if !is_true or !active:
			return
		active = false
		_switch_to_state(false, player.States.GROUND, "Glide"))
	detectors.on_wall.connect(func(is_true : bool):
		if !is_true or !active:
			return
		active = false
		_switch_to_state(false, player.States.CLIMB, "Glide"))
	

func _physics_process(_delta):
	if (player.current_state != activation_state and player.current_state != player.States.ABILITY 
		or player.main_vars.other_vars.ability_overide):
		current_state = false
		return
	elif player.current_state == activation_state or player.current_state == player.States.ABILITY:
		current_state = true
	
	if player.velocity.y < min_gliding_speed:
		return
	
	if !active and Input.is_action_pressed(player.inputs.Jump):
		player._reset_main_vars()
		_switch_to_state()
	
	if Input.is_action_just_released(player.inputs.Jump):
		player.air.fall_speed = 500
		player.main_vars.air_vars.gravity = 500.0
		player.main_vars.air_vars.gravity_increase = 5.0
		_switch_to_state(false, player.States.AIR, "Glide")
	
	if active:
		_glide()
	
	
	#if Input.is_action_just_pressed("Jump") and player.velocity.y > min_gliding_speed and !current:
		#_overide(true)
		#var tweener = get_tree().create_tween()
		#var time = player.air_state.fall_speed / 9600
		#tweener.tween_property(player, "velocity.y", min_gliding_speed, time)
	#elif Input.is_action_just_released("Jump"):
		#_overide(false)

func _glide():
	var air_movement = func air_movement():
		var direction = Input.get_axis(player.inputs.Left, player.inputs.Right)
		
		if (direction == player.main_vars.air_vars.movement_direction and 
			player.main_vars.air_vars.movement_direction != 0 and 
			player.velocity.x * direction <= player.main_vars.ground_vars.speed):
				player.velocity.x = player.main_vars.ground_vars.speed * direction
		
		elif direction != player.main_vars.air_vars.movement_direction and direction != 0:
			player.velocity.x = lerp(player.velocity.x, 
				player.main_vars.ground_vars.speed * direction, 0.1)
		
		elif direction == 0 and player.velocity.x != 0:
			player.velocity.x = lerpf(player.velocity.x, 0.0, 0.01)
	
	air_movement.call()
	sprite.play("glide")
	player.velocity.y = min_gliding_speed
	
	turn()

func turn():
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true
























	#if player.is_on_floor() and in_action:
		#reset()
	#
	#elif Input.is_action_pressed("Jump") and player.current_state == activation_state and player.velocity.y > min_gliding_speed:
		#overide()
		#player.velocity.y = lerp(player.velocity.y, float(min_gliding_speed), 0.002)
	#
	#elif in_action and Input.is_action_pressed("Jump"):
		#$"../../Sprite".play("glide")
		#player.main_vars.air_vars.gravity += 1
		#player.velocity.y += 1
		#
		#air_movement()
		#
		#turn()
	#
	#elif in_action:
		#reset()
#
#func air_movement():
	#var direction = Input.get_axis("Left", "Right")
	#var current_direction = 0
	#
	#
	#if player.velocity.x == 0:
		#current_direction = 0
	#elif player.velocity.x > 0:
		#current_direction = 1
	#elif player.velocity.x < 0:
		#current_direction = -1
	#
	#if direction == current_direction:
		#player.velocity.x = lerp(player.velocity.x, player.main_vars.ground_vars.speed * direction, 0.3)
	#elif direction != current_direction:
		#player.velocity.x = lerp(player.velocity.x, player.main_vars.ground_vars.speed * direction, 0.05)
