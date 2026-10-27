extends Node

signal switch(new_state, additional)

@export var player : Player
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

@export var wait_time : float
var clock := Timer

var fall_speed := 0.0
var coyote_timer : Timer

var current := false

func _ready():
	detectors.on_ground.connect(func(is_true : bool):
		if !current or !is_true:
			return
		switch.emit(player.States.GROUND, "Land", fall_speed))
	detectors.on_wall.connect(func(is_true : bool):
		if !current or !is_true:
			return
		switch.emit(player.States.CLIMB, "WallHit"))
	detectors.on_roof.connect(func(is_true : bool):
		if !current or !is_true:
			return
		fall_speed = -25)
	
	coyote_timer = Timer.new()
	
	add_child(coyote_timer)
	coyote_timer.wait_time = wait_time
	coyote_timer.one_shot = true

func _physics_process(_delta):
	if player.current_state != player.States.AIR:
		current = false
		return
	elif player.current_state == player.States.AIR:
		current = true
	
	if Input.is_action_pressed("Jump") and !coyote_timer.is_stopped():
		coyote_timer.stop()
		_jump()
	
	_variable_jump()
	_air()

func _air():
	var air_movement = func air_movement():
		var direction = Input.get_axis("Left", "Right")
		
		if (direction == player.main_vars.air_vars.movement_direction and 
			player.main_vars.air_vars.movement_direction != 0 and 
			player.velocity.x * direction <= player.main_vars.ground_vars.speed):
				player.velocity.x = player.main_vars.ground_vars.speed * direction
		
		elif direction != player.main_vars.air_vars.movement_direction and direction != 0:
			player.velocity.x = lerp(player.velocity.x, 
				player.main_vars.ground_vars.speed * direction, 0.1)
		
		elif direction == 0 and player.velocity.x != 0:
			player.velocity.x = lerpf(player.velocity.x, 0.0, 0.005)
		
	var drop = func drop():
		if fall_speed < player.TERMINAL_VELOCITY: # Checks and adjusts the current gravity
			fall_speed += player.main_vars.air_vars.gravity
			player.main_vars.air_vars.gravity += player.main_vars.air_vars.gravity_increase
		
		if Input.is_action_pressed("Down"):
			fall_speed += player.main_vars.air_vars.gravity
		
		if fall_speed > -150 and fall_speed < 0:
			fall_speed = 100
		
		player.velocity.y = fall_speed
	
	air_movement.call()
	drop.call()
	_turn()


func _coyote_time():
	coyote_timer.start()
func _variable_jump():
	if Input.is_action_just_released("Jump") and fall_speed > 0:
		fall_speed -= 200

func _jump(climbing : bool = false):
	fall_speed = -player.main_vars.air_vars.jump_strength
	player._reset_main_vars(1)
	
	
	if climbing:
		player.velocity.x = -player.main_vars.ground_vars.speed * player._get_sprite_rotation()
		player.position.x -= 10 * player._get_sprite_rotation()
		#player.main_vars.air_vars.gravity = 100
func _turn():
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true
