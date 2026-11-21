extends Ability

const WINDUP_MAX := 3
const COLLISION_POSITION := Vector2(100,100)

enum States {WINDING_UP, PUNCHING, HIT, FLYING, NOTHING}

var punch_states := States.NOTHING
var punch_timer : Timer
var punch_area : Area2D

var windup_time := 0.3
var windup_level := 1
var punch_strength : int = 500

var gravity = 50

var reset = false

func _ready():
	punch_timer = Timer.new()
	add_child(punch_timer)
	punch_timer.timeout.connect(_punch_timeout)
	
	punch_area = Area2D.new()
	add_child(punch_area)
	
	punch_area.body_entered.connect(_punch_entered)
	
	activation_state = player.States.GROUND
	
	detectors.on_ground.connect(func(is_true : bool):
		if !active:
			return
		if is_true and punch_states == States.FLYING:
			reset = true
			_switch_to_state(false, player.States.GROUND, "Punch")
		elif !is_true and punch_states == States.PUNCHING:
			reset = true
			_switch_to_state(false, player.States.AIR, "Punch"))
	detectors.on_wall.connect(func(is_true : bool):
		if !is_true or !active:
			return
		if punch_states == States.PUNCHING:
			punch_states = States.FLYING
			_initate_flying())

func _physics_process(_delta):
	if (player.current_state != activation_state and player.current_state != player.States.ABILITY 
		or player.main_vars.other_vars.ability_overide):
		current_state = false
		return
	elif player.current_state == activation_state or player.current_state == player.States.ABILITY:
		current_state = true
	
	if Input.is_action_just_pressed(player.inputs.Ability) and punch_states == States.NOTHING:
		punch_states = States.WINDING_UP
		punch_timer.start()
	elif Input.is_action_just_released(player.inputs.Ability) and punch_states == States.WINDING_UP:
		punch_states = States.PUNCHING
		punch_timer.stop()
		_initiate_punch()
	
	_match_state()

func _initiate_punch():
	player.velocity.x = punch_strength * player._get_sprite_rotation()
	_switch_to_state(true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.5)
func _initate_flying():
	player.velocity.x = punch_strength * -player._get_sprite_rotation()
	player.velocity.y = -500

func _punch_timeout():
	if windup_level > WINDUP_MAX:
		return
	
	if windup_level == 1:
		punch_strength = 2000
	elif windup_level == 2:
		punch_strength = 4000
	else:
		punch_strength = 6000
	
	windup_level += 1
	
	
	punch_timer.start(windup_time)
	#sprite.play(str("windup", windup_level))
func _punch_entered(body : Player):
	body.velocity.x = punch_strength * 2 * player._get_sprite_rotation()

func _match_state():
	if punch_states == States.WINDING_UP:
		sprite.play("land")
	
	elif punch_states == States.PUNCHING:
		sprite.play("ram")
	
	elif punch_states == States.FLYING:
		player.velocity.y += gravity
		gravity += 10

func _reset_vars():
	if reset:
		reset = false
		gravity = 50
		windup_level = 0
		punch_strength = 1000
		punch_states = States.NOTHING
