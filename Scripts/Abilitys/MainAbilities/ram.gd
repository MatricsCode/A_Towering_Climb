extends Ability

const MAX_SPEED := 4000.0

var ram_speed := 0.0
var ramming_addition := -100.0
var flying := false
var fall_speed := 25.0
var fall_gravity := 10.0
var fall_increase := 25.0

func _ability_ready():
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

func _physics_process(_delta):
	if (player.current_state != activation_state and player.current_state != player.States.ABILITY 
		or player.main_vars.other_vars.ability_overide):
		current_state = false
		_reset_vars()
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
func _reset_ability():
	if flying:
		_switch_to_state(false, player.States.AIR, "RamStopped")
	else:
		player.velocity = Vector2.ZERO
		_switch_to_state(false, player.States.GROUND, "RamStopped")
