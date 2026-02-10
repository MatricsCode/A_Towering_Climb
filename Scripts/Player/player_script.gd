extends CharacterBody2D

## --- Enums ---
enum States {GROUND, AIR, CLIMB, PAUSED, OVERIDDEN, EMPTY}

## --- Constants ---
const MAX_GRAVITY = 10000

## --- Variables ---
var current_state
var player = 0

var sounds = {
	"Walk" : preload("res://Sound Effects/Walking.mp3"),
	"Land" : preload("res://Sound Effects/Land.mp3"),
	"Jump" : preload("res://Sound Effects/Jump.mp3"),
	"Climb" : preload("res://Sound Effects/Climb.mp3"),}
var main_vars = { ## Main ariables
	ground_vars = {speed = 600},
	jump_vars = {jump_power = 1000, jump_increase = 1, gravity = 0, movement_direction = 0}, # Determins how fast the player increases in jump powe
	climbing_vars = {climbing_speed = 300},
	
	switching_vars = {switch_again = true},
	
	background_wiggle_vars = {background_changing = false},
	}

var camera_changing : Tween

var main_var_reset = [] ## The Array, gets auto-assigned in the ready function with the values of main_vars
var interactables = []
var shaking_camera = 0

## --- Nodes ---
#region Nodes
@onready var cam = $Camera2D 
@onready var sprite = $Sprite
@onready var wall_detector = $Detectors/WallDetectors
@onready var edge_detectors = $Detectors/EdgeDetectors
@onready var sweat = $Sweat
@onready var interact_detector = $InteractDetector
@onready var interacting = $Interact
#endregion

## ---- Functions ----
#region Inbuilt Functions
## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scene
	switch_costume()
	
	cam.enabled = is_multiplayer_authority() ## Checks if you are this player and grants/denies you the camera from this
	
	current_state = States.PAUSED
	
	print_rich("[color=red][shake level=20][pulse][wave amp=100][b] YOU HAVE DEACTIVATED THE CAMERA START ANIMATION!!!")
	
	camera_changing = get_tree().create_tween()
	cam.position = Vector2(-10000, -10000)
	camera_changing.set_ease(Tween.EASE_OUT)
	camera_changing.tween_property(cam, "position", Vector2(position.x, position.y), 3)
	
	await camera_changing.finished
	
	if is_multiplayer_authority():
		$AudioListener2D.make_current()
	
	current_state = States.AIR ## Autoloads the normal state into the player
	
	main_var_reset = main_vars.values() ## Loads all the values of main vars into main var reset, so that they are stored seperatly
	
	GlobalScript.paused.connect(pause_switch)
	GlobalScript.winner.connect(won)

func _physics_process(_delta):  ## Runs every physics frames
	if not is_multiplayer_authority():
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	if velocity.y != 0 and current_state == States.AIR:
		if Input.is_action_just_released("Jump") and 0 >velocity.y:
				main_vars.jump_vars.gravity += 50
	
	match current_state:
		States.GROUND:
			ground()
		States.AIR:
			air()
		States.CLIMB:
			climb()
		States.PAUSED:
			paused()
		States.OVERIDDEN:
			overidden()
		States.EMPTY:
			pass
		_:
			printerr("A unidentified state has been entered")
	
	if camera_changing.is_running() == false and current_state != States.PAUSED:
		camera_move()
	
	if shaking_camera != 0:
		camera_shake(shaking_camera)
	
	if shaking_camera == 0:
		cam.offset = lerp(cam.offset, Vector2.ZERO, 0.002)
	
	move_and_slide()
#endregion

#region State Functions
## --- state functions ---
func ground():
	
	## All of the different actions possible in the current state go here
	#region Main
	if velocity.x != 0: # This plays the correct animation, according to what the velocity is
		sprite.play("walk")
	elif velocity.x == 0:
		sprite.play("idle")
	
	if sprite.frame == 1 or sprite.frame == 5:
		play_sound(sounds["Walk"])
	
	if interactables.is_empty() == false:
		for i in interactables:
			for y in GlobalScript.player_abilitys:
				if i.activator == y:
					interacting.visible = true
	
	elif interactables.is_empty() == true:
		interacting.visible = false
	
	if interactables.is_empty() == false and Input.is_action_just_pressed("Interact"):
		for i in interactables:
			for y in GlobalScript.player_abilitys:
				if i.activator == y:
					i.interact(self)
	
	move()
	turn()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if Input.is_action_pressed("Jump"):
		switch(States.GROUND, States.AIR)
	
	if not is_on_floor() and not Input.is_action_pressed("Jump"):
		await get_tree().create_timer(0.1).timeout
		main_vars.jump_vars.gravity = 50
		switch(States.GROUND, States.AIR)
	
	elif not is_on_floor() and Input.is_action_pressed("Jump"):
		switch(States.GROUND, States.AIR)
	
	elif wall_detector.touching_wall():
		switch(States.GROUND, States.CLIMB)
	
	#endregion

func air(): 
	#region Functions
	var air_movement = func air_movement():
		var direction = Input.get_axis("Left", "Right")
		
		if direction == main_vars.jump_vars.movement_direction and main_vars.jump_vars.movement_direction != 0:
			velocity.x = main_vars.jump_vars.jump_power * direction / 1.5
		
		elif direction != main_vars.jump_vars.movement_direction and main_vars.jump_vars.movement_direction != 0:
			velocity.x += direction * main_vars.jump_vars.jump_power / 20
			velocity.x = clamp(velocity.x, -main_vars.jump_vars.jump_power, main_vars.jump_vars.jump_power)
		
		elif direction != main_vars.jump_vars.movement_direction and main_vars.jump_vars.movement_direction == 0:
			velocity.x += direction * main_vars.jump_vars.jump_power / 30
			velocity.x = clamp(velocity.x, -main_vars.jump_vars.jump_power, main_vars.jump_vars.jump_power)
		
		elif direction == 0 and velocity.x != 0:
			if velocity.x > 0:
				velocity.x += main_vars.jump_vars.jump_power / 100
			else:
				velocity.x -= main_vars.jump_vars.jump_power / 100
	
	## Variable Jump Height is in Physiscs Process!
	
	var drop = func drop():
		if velocity.y < MAX_GRAVITY: # Checks and adjusts the current gravity
			velocity.y += main_vars.jump_vars.gravity
			main_vars.jump_vars.gravity += 1
		
		#if velocity.y > -500:
		#	main_vars.jump_vars.gravity += 10

		
		if velocity.y > -500 and velocity.y < 0:
			velocity.y = 100 
	#endregion
	
	## All of the different actions possible in the current state go here
	#region Main
	
	## Checks if you are mid jump and falling
	if not is_on_floor(): #elif not is_on_floor():
			if velocity.y > 0:
				sprite.play("fall") # Plays the fall animation if you are traveling downward
			elif velocity.y < 0:
				sprite.play("jump")# Plays the jump animation if you are traveling upward
			
			air_movement.call()
			
			turn()
			drop.call()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if is_on_floor():
		switch(States.AIR, States.GROUND)
	
	if wall_detector.touching_wall():
		position.y -= 5
		switch(States.AIR, States.CLIMB)
	#endregion

func climb():
	## All of the different actions possible in the current state go here
	#region Main
	var input = Input.get_axis("Up", "Down") ## Accesses the current input
	
	if input != 0:
		velocity.y = main_vars.climbing_vars.climbing_speed * input ## Sets the Velocity to input
		sprite.play("climb")
	
	else:
		sprite.play("climb")
		sprite.stop()
		velocity.y = 0
	
	if sprite.frame == 1 or sprite.frame == 3:
		play_sound(sounds["Climb"])
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if not edge_detectors.on_edge():
		switch(States.CLIMB, States.GROUND)
	
	if Input.is_action_just_pressed("Jump"):
		switch(States.CLIMB, States.AIR)
	
	if is_on_floor():
		switch(States.CLIMB, States.GROUND)
	
	elif wall_detector.touching_wall() == false:
		switch(States.CLIMB, States.AIR)
	#endregion

func paused():
	if wall_detector.touching_wall() == false and not is_on_floor():
	
		if velocity.y < MAX_GRAVITY: # Checks and adjusts the current gravity
			velocity.y += main_vars.jump_vars.gravity
			main_vars.jump_vars.gravity += 1
			sprite.play("fall")
	
	elif wall_detector.touching_wall() == true and not is_on_floor():
		sprite.set_animation("climb")
	
	elif wall_detector.touching_wall() == true and is_on_floor():
		position.x += get_sprite_rotation() * -1 * 20
		sprite.play("idle")
	
	else:
		sprite.play("idle")
		velocity.x = lerp(velocity.x, 0.0, 0.4)

func overidden():
	pass
#endregion

## --- Signals ---

#region Interact Detector Signals
func _on_interact_detector_body_entered(body):
	interactables.append(body)

func _on_interact_detector_body_exited(body):
	interactables.erase(body)
#endregion


## ---- Other Functions ----

#region Main Other Functions
func move():
	var direction = Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = main_vars.ground_vars.speed * direction
	else:
		velocity.x = 0

func turn():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func play_sound(sound : Resource):
	$SFX.stream = sound
	$SFX.play()
	$SFX.pitch_scale = randf_range(0.95, 1.15)

func get_sprite_rotation():
	if sprite.flip_h == false:
		return 1
	else:
		return -1

func switch(old_state, new_state):
	if old_state == States.OVERIDDEN:
		current_state = new_state
		main_vars.jump_vars.gravity = 0
		return
	
	if main_vars.switching_vars.switch_again == false:
		return
	
	main_vars.switching_vars.switch_again = false
	
	if new_state == States.AIR:
		main_vars.jump_vars.gravity = 0
	
	if old_state == States.GROUND and new_state == States.AIR:
		reset_main_vars(0)
		
		if Input.is_action_pressed("Jump"):
			play_sound(sounds["Jump"])
			
			if velocity.x > 0:
				main_vars.jump_vars.movement_direction = 1
			elif velocity.x < 0:
				main_vars.jump_vars.movement_direction = -1
			else:
				main_vars.jump_vars.movement_direction = 0
			
			velocity.y = -main_vars.jump_vars.jump_power
		
		current_state = new_state
	
	elif old_state == States.AIR and new_state == States.GROUND:
		reset_main_vars(1)
		
		sprite.play("pre_jump")
		
		shaking_camera = 2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "velocity", Vector2(0,0), 0.1)
		
		await get_tree().create_timer(0.1).timeout
		shaking_camera = 0
		
		current_state = States.EMPTY
		
		velocity.x = 0
		
		play_sound(sounds["Land"])
		
		reset_main_vars(1)
		
		current_state = new_state
	
	elif old_state == States.CLIMB and new_state == States.AIR:
		reset_main_vars(1)
		reset_main_vars(2)
		
		if Input.is_action_pressed("Jump"):
			main_vars.jump_vars.movement_direction = get_sprite_rotation() * -1
			
			velocity.x = main_vars.jump_vars.jump_power * main_vars.jump_vars.movement_direction
			velocity.y = -main_vars.jump_vars.jump_power / 2
			sprite.play("fall")
		
		current_state = new_state
	
	elif old_state == States.GROUND and new_state == States.CLIMB:
		position.y -= 20
		current_state = new_state
		
	elif old_state == States.CLIMB and new_state == States.GROUND:
		if edge_detectors.on_edge():
			position.x += 20 * get_sprite_rotation() * -1
		
		else:
			position.x += 50 * get_sprite_rotation()
			position.y -= 50
		current_state = new_state
	
	else:
		current_state = new_state
	
	await get_tree().create_timer(0.25).timeout
	
	main_vars.switching_vars.switch_again = true

func camera_move():
	var input = Input.get_vector("Left", "Right", "Up", "Down")
	
	var multiplier
	
	if input.y == 0 or input.x == 0:
		multiplier = 1
	else:
		multiplier = 0.75
	
	if input.y < 0:
		cam.position.y = lerp(cam.position.y, $CameraPositions/Up.position.y * multiplier, 0.01)
	elif input.y > 0:
		cam.position.y = lerp(cam.position.y, $CameraPositions/Down.position.y * multiplier, 0.01)
	else:
		cam.position.y = lerp(cam.position.y, $CameraPositions/Middle.position.y * multiplier, 0.02)
	
	if input.x < 0:
		cam.position.x = lerp(cam.position.x, $CameraPositions/Left.position.x * multiplier, 0.01)
	elif input.x > 0:
		cam.position.x = lerp(cam.position.x, $CameraPositions/Right.position.x * multiplier, 0.01)
	else:
		cam.position.x = lerp(cam.position.x, $CameraPositions/Middle.position.x * multiplier, 0.02)

func camera_shake(shake_intensity : int):
	cam.offset = Vector2(randf_range(-shake_intensity * 10, shake_intensity * 10), randf_range(-shake_intensity * 10, shake_intensity * 10))

func overide(overidden2 : bool):
	if overidden2:
		print("Overide State")
		switch(current_state, States.OVERIDDEN)
	else:
		print("Overide the overide : ", current_state)
		switch(States.OVERIDDEN, States.AIR)
#endregion

#region Secondary Other Functions
## 0 = Ground, 1 = Air, 2 = Climb
func reset_main_vars(key : int):
	var keys = main_vars.keys()
	
	for i in main_vars.size():
		if i == key:
			main_vars[keys[i]] = main_var_reset[i]

func pause_switch():
	if current_state != States.PAUSED:
		switch(current_state, States.PAUSED)
	else:
		switch(States.PAUSED, States.AIR)

func background_rotation():
	if velocity.x < 600 and velocity.x > -600:
		return velocity.x / 2000
	elif velocity.x >= 600 or velocity.x <= -600:
		return velocity.x / 6000

func won(winners_name):
	switch(current_state, States.PAUSED)
	camera_changing = get_tree().create_tween()
	camera_changing.tween_property(cam, "position", GlobalScript.goal_position, 3)

func switch_costume():
	sprite.sprite_frames = GlobalScript.all_player_outfits[GlobalScript.player_outfits[player -1]]
	
#endregion
