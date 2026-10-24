extends CharacterBody2D
class_name Player

signal start()

@export_category("Nodes")
@export var player_source : PlayerSource
@export var sprite : AnimatedSprite2D
@export var wall_detector : Node2D
@export var edge_detectors : Node2D

@export_category("States")
@export var ground : Node
@export var air : Node
@export var climb : Node
@export var pause : Node

var steam_user : int
var character_user : int

## --- Enums ---
enum States {GROUND, AIR, CLIMB, PAUSED, OVERIDDEN, EMPTY}

## --- Constants ---

const MAX_GRAVITY = 1200

var sounds = {
	"Land" : preload("res://Sound Effects/Land.mp3"),
	"Jump" : preload("res://Sound Effects/Jump.mp3"),}

## --- Variables ---
var current_state
var ID

var main_vars = { ## Main variables
	"ground_vars" : {"speed" : 600},
	"air_vars" : {"jump_power" : 1250, "jump_increase" : 1, "gravity" : 0, "gravity_increase" : 1, "movement_direction" : 0},
	"climbing_vars" : {"climbing_speed" : 300},
	
	"switching_vars" : {"switch_again" : true},}

var main_vars_reset = []

## --- Nodes ---


## ---- Functions ----
#region Inbuilt Functions
## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scenes
	ground.switch.connect(_switch_ground)
	air.switch.connect(_switch_air)
	climb.switch.connect(_switch_climb)
	pause.switch.connect(_switch_pause)
	
	start.connect(func():
		sprite.sprite_frames = player_source.sprite_frame
		
		
		for i in main_vars:
			for y in main_vars[i]:
				main_vars_reset.append(main_vars.get(i).get(y))
		
		if is_multiplayer_authority():
			$AudioListener2D.make_current()
		
		current_state = States.AIR ## Autoloads the normal state into the player
		
		
		#Signals.paused.connect(pause_switch)
		#Signals.winner.connect(won)
		)

func _physics_process(_delta):  ## Runs every physics frames
	#GlobalScript.player_attributes.get(ID)["Position"] = position
	#
	#if wall_detector.touching_wall():
		#set_collision_layer_value(2,true)
	#else:
		#set_collision_layer_value(2,false)
	
	if not is_multiplayer_authority():
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	if velocity.y != 0 and current_state == States.AIR:
		if Input.is_action_just_released("Jump") and 0 > velocity.y:
				main_vars.air_vars.gravity_increase += 2
				main_vars.air_vars.gravity += 10
	
	#match current_state:
		#States.GROUND:
			#ground()
		#States.AIR:
			#air()
		#States.CLIMB:
			#climb()
		#States.PAUSED:
			#paused()
		#States.OVERIDDEN:
			#overidden()
		#States.EMPTY:
			#pass
		#_:
			#printerr("A unidentified state has been entered")
	
	#if camera_changing.is_running() == false and current_state != States.PAUSED:
		#camera_move()
	#
	#if shaking_camera != 0:
		#camera_shake(shaking_camera)
	#
	#if shaking_camera == 0:
		#cam.offset = lerp(cam.offset, Vector2.ZERO, 0.002)
	
	move_and_slide()
#endregion

## --- Signals ---

#region Interact Detector Signals
#func _on_interact_detector_body_entered(body):
	#for i in GlobalScript.player_attributes.get(ID).get("Abilities"):
		#if body.activator == i:
			#interaction_indicator.visible = true
			#interactables.append(body)
			#body.entered(true)
#
#func _on_interact_detector_body_exited(body):
	#interactables.erase(body)
	#if interactables.is_empty():
		#interaction_indicator.visible = false
	#body.entered(false)
#endregion


func _switch_ground(new_state : States, additional = ""):
	current_state = new_state
	if additional == "":
		pass
	else:
		pass
func _switch_air(new_state : States, fall_speed = 0):
	current_state = new_state
func _switch_climb(new_state : States, additional = ""):
	current_state = new_state
	if additional == "":
		pass
	else:
		pass
func _switch_pause(new_state : States, additional = ""):
	current_state = new_state
	if additional == "":
		pass
	else:
		pass

#region Main Other Functions
func _play_sound(sound : Resource):
	$SFX.stream = sound
	$SFX.play()
	$SFX.pitch_scale = randf_range(0.95, 1.15)

func get_sprite_rotation():
	if sprite.flip_h == false:
		return 1
	else:
		return -1

func _switch(old_state, new_state):
	
	if old_state == States.OVERIDDEN:
		current_state = new_state
		main_vars.air_vars.gravity = 0
		return
	
	if main_vars.switching_vars.switch_again == false:
		return
	
	main_vars.switching_vars.switch_again = false
	
	if new_state == States.AIR:
		main_vars.air_vars.gravity = 0
	
	#if new_state == States.CLIMB:
		#var orrientation = wall_detector.touching_wall(true)
		#
		#if orrientation != get_sprite_rotation():
			#sprite.flip_h = not sprite.flip_h
	
	if old_state == States.GROUND and new_state == States.AIR:
		reset_main_vars(0)
		
		if Input.is_action_pressed("Jump"):
			if velocity.x > 0:
				main_vars.air_vars.movement_direction = 1
			elif velocity.x < 0:
				main_vars.air_vars.movement_direction = -1
			else:
				main_vars.air_vars.movement_direction = 0
			
			velocity.y = -main_vars.air_vars.jump_power
		
		current_state = new_state
	
	elif old_state == States.AIR and new_state == States.GROUND:
		reset_main_vars(1)
		
		sprite.play("pre_jump")
		
		#shaking_camera = 2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "velocity", Vector2(0,0), 0.1)
		
		await get_tree().create_timer(0.1).timeout
		#shaking_camera = 0
		
		current_state = States.EMPTY
		
		velocity.x = 0
		
		reset_main_vars(1)
		
		current_state = new_state
	
	elif old_state == States.CLIMB and new_state == States.AIR:
		reset_main_vars(1)
		reset_main_vars(2)
		
		main_vars.air_vars.gravity = 20
		main_vars.air_vars.gravity_increase = 10
		
		if Input.is_action_pressed("Jump"):
			main_vars.air_vars.movement_direction = get_sprite_rotation() * -1
			
			velocity.x = main_vars.ground_vars.speed * main_vars.air_vars.movement_direction * 2
			velocity.y = -main_vars.air_vars.jump_power
			sprite.play("fall")
		
		current_state = new_state
	
	elif old_state == States.GROUND and new_state == States.CLIMB:
		if wall_detector.touching_wall(true) != get_sprite_rotation():
			if sprite.flip_h == false:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		
		position.y -= 20
		current_state = new_state
		
	elif old_state == States.CLIMB and new_state == States.GROUND:
		reset_main_vars(1)
		reset_main_vars(2)
		
		
		if edge_detectors.on_edge():
			position.x += 50 * get_sprite_rotation() * -1
		
		else:
			position.x += 50 * get_sprite_rotation()
			position.y -= 40
		
		velocity = Vector2.ZERO
		current_state = new_state
	
	else:
		current_state = new_state
	
	await get_tree().create_timer(0.25).timeout
	
	main_vars.switching_vars.switch_again = true

#func camera_move():
	#var input = Input.get_vector("Left", "Right", "Up", "Down")
	#
	#var multiplier
	#
	#if input.y == 0 or input.x == 0:
		#multiplier = 1
	#else:
		#multiplier = 0.75
	#
	#if input.y < 0:
		#cam.position.y = lerp(cam.position.y, $CameraPositions/Up.position.y * multiplier, 0.01)
	#elif input.y > 0:
		#cam.position.y = lerp(cam.position.y, $CameraPositions/Down.position.y * multiplier, 0.01)
	#else:
		#cam.position.y = lerp(cam.position.y, $CameraPositions/Middle.position.y * multiplier, 0.02)
	#
	#if input.x < 0:
		#cam.position.x = lerp(cam.position.x, $CameraPositions/Left.position.x * multiplier, 0.01)
	#elif input.x > 0:
		#cam.position.x = lerp(cam.position.x, $CameraPositions/Right.position.x * multiplier, 0.01)
	#else:
		#cam.position.x = lerp(cam.position.x, $CameraPositions/Middle.position.x * multiplier, 0.02)
#
#func camera_zoom(intensity : float,  duration : float):
	#var cam_tween = get_tree().create_tween()
	#cam_tween.set_parallel(true)
	#cam_tween.tween_property(cam, "zoom", Vector2(intensity,intensity), duration)
#func camera_shake(shake_intensity : int):
	#cam.offset = Vector2(randf_range(-shake_intensity * 10, shake_intensity * 10), randf_range(-shake_intensity * 10, shake_intensity * 10))

func overide(overidden2 : bool):
	if overidden2:
		_switch(current_state, States.OVERIDDEN)
	else:
		_switch(States.OVERIDDEN, States.AIR)
#endregion

#region Secondary Other Functions
func reset_main_vars(key : int): ## 0 = Ground, 1 = Air, 2 = Climb
	var keys = main_vars.keys()
	var current_key = keys[key]
	
	var current_item = 0
	
	for i in main_vars:
		
		for y in main_vars.get(i).size():
			
			if current_key == i:
				var temp = main_vars_reset.get(current_item)
				var keys_2 = main_vars.get(i).keys()
				
				main_vars.get(i).set(keys_2[y], temp)
			
			current_item += 1

func pause_switch():
	if current_state != States.PAUSED:
		_switch(current_state, States.PAUSED)
	else:
		_switch(States.PAUSED, States.AIR)

func background_rotation():
	if velocity.x < 600 and velocity.x > -600:
		return velocity.x / 2000
	elif velocity.x >= 600 or velocity.x <= -600:
		return velocity.x / 6000

#func won(winners_name):
	#switch(current_state, States.PAUSED)
	#camera_changing = get_tree().create_tween()
	#GlobalScript.important_positions.keys()
	#
	#var goal_pos
	#
	#for i in GlobalScript.important_positions.keys():
		#if GlobalScript.important_positions.get(i) == 4:
			#goal_pos = i
	#
	#camera_changing.tween_property(cam, "position", goal_pos, 4)
#endregion
