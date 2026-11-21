extends Ability

const WINDUP_MAX := 3
const COLLISION_POSITION := Vector2(100,100)

enum States {WINDING_UP, PUNCHING, HIT, FLYING, NOTHING}

var punch_states := States.NOTHING
var punch_timer : Timer
var punch_area : Area2D

var windup_time := 0.5
var windup_level := 1
var punch_strength : int = 500
var friction : float = 0.3

var gravity = 50

var reset = false

var tween : Tween

func _ready():
	punch_timer = Timer.new()
	add_child(punch_timer)
	punch_timer.wait_time = windup_time
	punch_timer.timeout.connect(_punch_timeout)
	
	punch_area = Area2D.new()
	punch_area.set_collision_layer_value(1, false)
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
			_hit_wall())

func _physics_process(_delta):
	punch_area.position = player.position
	
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
	var collider = CollisionShape2D.new()
	punch_area.add_child(collider)
	collider.position = Vector2(45 * player._get_sprite_rotation(), -71.0)
	collider.shape = RectangleShape2D.new()
	
	Signals.camera_zoom.emit(player.player_source.player_number, 0.5, 0.25)
	player.velocity.x = punch_strength * player._get_sprite_rotation()
	_switch_to_state(true)
	tween = get_tree().create_tween()
	tween.tween_property(player, "velocity", Vector2.ZERO, friction)
	await get_tree().create_timer(friction).timeout
	if active:
		collider.queue_free()
		reset = true
		_switch_to_state(false, player.States.GROUND, "Punch")
func _hit_wall():
	if tween.is_running():
		tween.kill()
	
	player.velocity.x = 0
	player.velocity.y = 0

func _punch_timeout():
	if windup_level > WINDUP_MAX:
		return
	
	if windup_level == 1:
		punch_strength = 4000
		Signals. camera_zoom.emit(player.player_source.player_number, 0.65, windup_time/2)
	elif windup_level == 2:
		punch_strength = 6000
		Signals. camera_zoom.emit(player.player_source.player_number, 0.8, windup_time/2)
	else:
		punch_strength = 8000
		Signals. camera_zoom.emit(player.player_source.player_number, 1, windup_time/2)
	
	windup_level += 1
	
	
	punch_timer.start(windup_time)
	#sprite.play(str("windup", windup_level))
func _punch_entered(body : Player):
	body.current_state = body.States.AIR
	body.velocity.x = punch_strength * 0.1 * player._get_sprite_rotation()
	body.velocity.y = -1000

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
		windup_level = 1
		punch_strength = 1000
		punch_states = States.NOTHING
