extends CharacterBody2D
class_name Player

signal start()

@export_group("Nodes")
@export var player_source : PlayerSource
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D
@export var animations : Node

@export_group("States")
@export var ground : Node
@export var air : Node
@export var climb : Node
@export var pause : Node

## --- Enums ---
enum States {GROUND, AIR, CLIMB, PAUSE, OVERIDDEN, SWITCHING, EMPTY}

## --- Constants ---

const TERMINAL_VELOCITY := 2400

var sounds = {
	"Land" : preload("res://Sound Effects/Land.mp3"),
	"Jump" : preload("res://Sound Effects/Jump.mp3"),}

## --- Variables ---
var current_state
var ID

var main_vars = { ## Main variables
	"ground_vars" : {"speed" : 600},
	"air_vars" : {"jump_strength" : 1250, "jump_increase" : 1, 
		"gravity" : 0, "gravity_increase" : 2, "movement_direction" : 0},
	"climbing_vars" : {"climbing_speed" : 300},
	
	"other_vars" : {"can_switch" : true, "can_move" : false},}

var main_vars_reset = []

## ---- Functions ----
func _ready(): ## Runns as soon as the player is loaded into the scenes
	position.y -= 25
	
	current_state = States.AIR
	
	Signals.lobby_finished_game.connect(func(winner : Player):
		current_state = States.OVERIDDEN
		velocity = Vector2.ZERO
		animations.overide = true
		
		if winner == self:
			_won()
		else:
			_lost())
	
	Signals.start_anim_finished.connect(func():
		main_vars.get("other_vars")["can_move"] = true)
	
	ground.switch.connect(_switch_ground)
	air.switch.connect(_switch_air)
	climb.switch.connect(_switch_climb)
	pause.switch.connect(_switch_pause)
	
	for i in main_vars:
		for y in main_vars[i]:
			main_vars_reset.append(main_vars.get(i).get(y))
	
	if is_multiplayer_authority():
		$AudioListener2D.make_current()
	
	start.connect(func():
		sprite.sprite_frames = player_source.sprite_frame
		)

func _physics_process(_delta):  ## Runs every physics frames
	#GlobalScript.player_attributes.get(ID)["Position"] = position
	#
	#if wall_detector.touching_wall():
		#set_collision_layer_value(2,true)
	#else:
		#set_collision_layer_value(2,false)
	
	if not is_multiplayer_authority() and main_vars.get("other_vars")["can_move"]:
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	#match current_state:
		#States.GROUND:
			#ground()
		#States.AIR:
			#air()
		#States.CLIMB:
			#climb()
		#States.PAUSE:
			#paused()
		#States.OVERIDDEN:
			#overidden()
		#States.EMPTY:
			#pass
		#_:
			#printerr("A unidentified state has been entered")
	
	#if camera_changing.is_running() == false and current_state != States.PAUSE:
		#camera_move()
	#
	#if shaking_camera != 0:
		#camera_shake(shaking_camera)
	#
	#if shaking_camera == 0:
		#cam.offset = lerp(cam.offset, Vector2.ZERO, 0.002)
	
	move_and_slide()

## -- Switch Functions --
func _switch_ground(new_state : States, additional := ""):
	if !main_vars.get("other_vars")["can_switch"]:
		return
	
	if new_state == States.AIR:
		if additional == "Jump":
			air._jump()
		elif additional == "Fall":
			air._coyote_time()
		
	elif new_state == States.CLIMB:
		position.y -= 25
	
	current_state = new_state
	_switch_timeout()
func _switch_air(new_state : States, additional := "",  fall_speed := 0.0):
	if !main_vars.get("other_vars")["can_switch"]:
		return
	
	if additional == "Climb":
		climb._slide()
	elif additional == "Land":
		current_state = States.OVERIDDEN
		var crouch_time = fall_speed / 1200.0
		animations.overide = true
		sprite.play("land")
		
		
		velocity = Vector2.ZERO
		current_state = States.OVERIDDEN
		
		await get_tree().create_timer(crouch_time).timeout
		animations.overide = false
		
		_reset_main_vars()
	
	current_state = new_state
	_switch_timeout()
func _switch_climb(new_state : States, additional := ""):
	if !main_vars.get("other_vars")["can_switch"]:
		return
	
	if new_state == States.GROUND:
		if additional == "Finished":
			position.x += 25 * _get_sprite_rotation() * -1
		elif additional == "OnEdge":
			position.y -= 82.0
			position.x += 50 * _get_sprite_rotation()
			velocity = Vector2.ZERO
		
	elif new_state == States.AIR:
		if additional == "Jump":
			air._jump(true)
	
	current_state = new_state
	_switch_timeout()
func _switch_pause(new_state : States, additional := ""):
	current_state = new_state
	if additional == "":
		pass
	else:
		pass

func _switch_timeout():
	main_vars.other_vars.can_switch = false
	await get_tree().create_timer(0.025).timeout
	main_vars.other_vars.can_switch = true

func _reset_main_vars(key : int = -1): ## 0 = Ground, 1 = Air, 2 = Climb
	var keys = main_vars.keys()
	var current_key = keys[key]
	
	var current_item = 0
	
	for i in main_vars:
		
		for y in main_vars.get(i).size():
			
			if key != -1 and  current_key == i:
				var temp = main_vars_reset.get(current_item)
				var keys_2 = main_vars.get(i).keys()
				
				main_vars.get(i).set(keys_2[y], temp)
			
			else:
				var temp = main_vars_reset.get(current_item)
				var keys_2 = main_vars.get(i).keys()
				
				main_vars.get(i).set(keys_2[y], temp)
			
			
			current_item += 1

func _play_sound(sound : Resource):
	$SFX.stream = sound
	$SFX.play()
	$SFX.pitch_scale = randf_range(0.95, 1.15)
func _get_sprite_rotation():
	if sprite.flip_h == false:
		return 1
	else:
		return -1

func _won():
	sprite.play("fall")
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
func _lost():
	sprite.play("fall")
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
