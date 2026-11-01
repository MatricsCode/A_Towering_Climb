extends Ability

var min_gliding_speed = 500

func _ready():
	activation_state = player.States.AIR
	
	detectors.on_ground.connect(func(is_true : bool):
		if !is_true or !active:
			return
		active = false
		_switch_to_state(player.States.GROUND, "Gliding"))
	

func _physics_process(_delta):
	if player.current_state != activation_state and player.current_state != player.States.OVERIDDEN:
		current_state = false
		return
	elif player.current_state == activation_state or player.current_state == player.States.OVERIDDEN:
		current_state = true
	
	if player.velocity.y < min_gliding_speed:
		return
	
	print("Checking")
	
	if !active and Input.is_action_pressed("Jump"):
		player._reset_main_vars()
		_overide(true)
	
	if Input.is_action_just_released("Jump"):
		player.air.fall_speed = 500
		_switch_to_state(player.States.AIR, "Gliding")
	
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
	print("Gliding")
	sprite.play("glide")
	player.velocity.y = min_gliding_speed
	
	


























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
#
#func turn():
	#if player.velocity.x > 0:
		#$"../../Sprite".flip_h = false
	#elif player.velocity.x < 0:
		#$"../../Sprite".flip_h = true
