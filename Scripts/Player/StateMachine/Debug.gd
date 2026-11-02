extends Node

@export_group("Nodes")
@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

var current := false
var acceleration := 0.0

func _ready():
	Signals.debug.connect(func(is_debug : bool):
		if is_debug:
			_debug_start()
		else:
			_debug_stop())

func _physics_process(delta):
	if !current:
		return
	
	_debug()

func _debug():
	var input_vector := Input.get_vector("Left", "Right", "Up", "Down")
	
	if input_vector.y == 1:
		sprite.flip_v = true
		sprite.play("jump")
	elif input_vector.y == -1:
		sprite.flip_v = false
		sprite.play("jump")
	else:
		sprite.flip_v = false
	
	if input_vector.x == -1:
		sprite.flip_h = true
	elif input_vector.x == 1:
		sprite.flip_h = false
	
	if input_vector.x != 0 and input_vector.y == 0:
		sprite.play("walk")
	
	if input_vector == Vector2.ZERO:
		sprite.play("idle")
	
	if input_vector == Vector2.ZERO:
		acceleration = 10.0
	else:
		acceleration *= 1.5
		acceleration = clampf(acceleration, 0.0,100.0)
	
	player.position += input_vector * Vector2(acceleration,acceleration)

func _debug_start():
	current = true
	player.velocity = Vector2.ZERO
	player.set_collision_layer_value(1, false)
	player.set_collision_layer_value(3, false)
	player.set_collision_mask_value(2, false)
	player.set_collision_mask_value(4, false)
	player.current_state = player.States.OVERIDDEN
	detectors.ignore = true
func _debug_stop():
	current = false
	player.velocity = Vector2.ZERO
	player.set_collision_layer_value(1, true)
	player.set_collision_layer_value(3, true)
	player.set_collision_mask_value(2, true)
	player.set_collision_mask_value(4, true)
	player.current_state = player.States.AIR
	detectors.ignore = false
	detectors.is_on_roof = false
	detectors.is_on_ground = false
	detectors.is_on_wall = false
	detectors.is_on_edge = false
