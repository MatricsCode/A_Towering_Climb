extends Ability

const MAX_SPEED := 4000.0

var ram_speed := 0.0
var ramming_addition := -100.0
var flying := false
var fall_speed := 25.0
var fall_gravity := 10.0
var fall_increase := 25.0

func _ready():
	activation_state = player.States.GROUND
	
	detectors.on_ground.connect(func(is_true : bool):
		if !active:
			return
		
		if flying and is_true:
			_switch_to_state(false, player.States.GROUND, "Ram_Fling")
		elif !flying and !is_true:
			player.velocity.x = 50 * player._get_sprite_rotation()
			_switch_to_state(false, player.States.AIR, "Ram"))
	detectors.on_wall.connect(func(is_true : bool):
		if !active or !is_true:
			return
		
		if flying:
			_switch_to_state(false, player.States.AIR, "Ram_Fling")
		elif !flying:
			flying = true
			player.velocity.x = ram_speed * -0.45 * player._get_sprite_rotation()
			fall_speed = ram_speed * -0.6)

func _physics_process(delta):
	if player.current_state != activation_state and player.current_state != player.States.ABILITY:
		current_state = false
		return
	elif player.current_state == activation_state or player.current_state == player.States.ABILITY:
		current_state = true
	
	if player.current_state == player.States.ABILITY and !did_switch:
		return
	
	if Input.is_action_pressed(player.inputs.Ability) and !active:
		_switch_to_state()
	
	elif Input.is_action_just_released(player.inputs.Ability) and active and !flying:
		_switch_to_state(false, player.States.GROUND, "Ram")
	
	if active and !flying:
		_ram()
	elif active and flying:
		_fall()

func _ram():
	ram_speed += ramming_addition
	ramming_addition += 25
	
	ram_speed = clamp(ram_speed, -MAX_SPEED, MAX_SPEED)
	
	player.velocity.x = ram_speed * player._get_sprite_rotation()
	
	sprite.play("ram")





















#var flying = false
#var current_speed = 0
#
#var gravity = 100
#var timer = 0
#
#var position = Vector2.ZERO
#
#func _physics_process(_delta):
	#if Input.is_action_pressed("Ability") and player.current_state == activation_state and player.is_on_floor():
		#player.set_collision_mask_value(3, false)
		#flying = false
		#
		#player.velocity.x += 100 * player._get_sprite_rotation()
		#current_speed = player.velocity.x
		#
		##if player.velocity.x * direction < 0:
			##player.velocity.x *= direction
		#$"../../Sprite".play("ram")
		#
		#overide()
	#
	#if Input.is_action_pressed("Ability") and in_action and !flying:
		#var range
		#
		#range = player.position.x - position.x
		#
		#if range < 10 and range > -10 and player.velocity.x == 0:
			#flying = true
			#
			#player.position.y += -50
			#player.position.x += -70 * player._get_sprite_rotation()
			#
			#player.velocity.y = -2 * current_speed * player._get_sprite_rotation()
			#player.velocity.x = 1.5 * current_speed
			#
			#clamp(player.velocity.y, -10000, 100000)
			#clamp(player.velocity.x, -10000, 100000)
			#
			#if player._get_sprite_rotation() == -1:
				#player.sprite.flip_h = false
			#else:
				#player.sprite.flip_h = true
		#
		#var direction = player._get_sprite_rotation()
		#current_speed = lerp(current_speed, 1500.0 * float(direction), 0.02)
		#player.velocity.x = current_speed
		#
		#position = player.position
	#
	#if not Input.is_action_pressed("Ability") and in_action and !flying:
		#reset()
		#timer = 0
		#player.velocity.x = 0
		#player.set_collision_mask_value(3, true)
	#
	#elif not player.is_on_floor() and in_action and !flying:
		#reset()
		#timer = 0
		#player.set_collision_mask_value(3, true)
	#
	#if flying:
		#fly()
		#timer += 0.1
		#if player.velocity.x != -1.5 * current_speed:
			#player.velocity.x = -1.5 * current_speed
#
#func fly():
	#if player.velocity.y < player.MAX_GRAVITY: # Checks and adjusts the current gravity
			#player.velocity.y += gravity
			#gravity += 10
	#
	#if player.velocity.y > -500 and player.velocity.y < 0:
			#player.velocity.y = 100 
	#
	#if player.velocity.x != -1.5 * current_speed:
		#player.velocity.x = -1.5 * current_speed
	#
	#if player.is_on_floor() and timer > 1:
		#gravity = 100
		#timer = 0
		#flying = false
		#current_speed = player.velocity.x
	#
	#position = player.position
func _fall():
	sprite.play("fall")
	
	if fall_speed < player.TERMINAL_VELOCITY: # Checks and adjusts the current gravity
		fall_speed += fall_gravity
		fall_gravity += fall_increase
	
	player.velocity.y = fall_speed

func _reset_vars():
	ram_speed = 0.0
	ramming_addition = -100.0
	flying = false
	fall_speed = 25.0
	fall_gravity = 10.0
	fall_increase = 25.0
	
	
	
