extends CharacterBody2D
class_name player

## --- Enums ---
enum States {GROUND, AIR, CLIMB, RAM, EMPTY}


## --- Constants ---
const MAX_JUMP = 1000
const MAX_GRAVITY = 10000


## --- Variables ---
var current_state

var main_vars = { ## Main ariables
	speed = 600, # Determins how much the player can move in one frame
	jump_power = 750,  # Determins the height of the players jump
	jump_increase = 1, # Determins how fast the player increases in jump power
	gravity = 0, # Determins at what speed the player falls down
	glide_gravity = 100, # Determins at what speed the player falls down once gliding
	climbing_speed = 300,} # How fast the player can climb

var main_var_reset = [] ## The Array, gets auto-assigned in the ready function with the values of main_vars


## --- Nodes ---
@onready var cam = $Camera2D 
@onready var sprite = $Sprite
@onready var wall_detector = $WallDetectors
@onready var edge_detector = $EdgeDetectors
@onready var bump_detectors = $BumpDetectors


## --- Export Variables ---
@export var velocity2 = velocity ## Allows the Multiplayer Synchronizer to sync the velocity


## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scene
	
	cam.enabled = is_multiplayer_authority() ## Checks if you are this player and grants/denies you the camera from this
	
	current_state = States.AIR ## Autoloads the normal state into the player
	
	main_var_reset = main_vars.values() ## Loads all the values of main vars into main var reset, so that they are stored seperatly
	
	sprite.sprite_frames = GlobalScript.current_outfit

func _physics_process(delta):  ## Runs every physics frames
	
	if not is_multiplayer_authority():
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	match current_state:
		States.GROUND:
			ground()
		States.AIR:
			air()
		States.CLIMB:
			climb()
		States.RAM:
			ram()
		States.EMPTY:
			pass
		_:
			print("A unidentified state has been entered")
	
	move_and_slide()


## --- Self made functions ---
func ground():
	## All of the different actions possible in the current state go here
	#region Main
	if velocity.x != 0: # This plays the correct animation, according to what the velocity is
		sprite.play("walk")
	elif velocity.x == 0:
		sprite.play("idle")
	
	move()
	turn()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if Input.is_action_pressed("Jump"):
		switch(States.GROUND, States.AIR)
	
	elif Input.is_action_pressed("Ram"):
		switch(States.GROUND, States.RAM)
	
	if not is_on_floor():
		main_vars.gravity = 50
		switch(States.GROUND, States.AIR)
	
	elif wall_detector.touching_wall():
		position.y -= 5
		switch(States.GROUND, States.CLIMB)
	#endregion

func air():
	
	#region Functions
	var air_movement = func air_movement():
			var direction = Input.get_axis("Left", "Right")
			var current_direction = 0
			
			
			if velocity.x == 0:
				current_direction = 0
			elif velocity.x > 0:
				current_direction = 1
			elif velocity.x < 0:
				current_direction = -1
			
			if direction == current_direction:
				velocity.x = lerp(velocity.x, main_vars.speed * direction, 0.3)
			elif direction != current_direction:
				velocity.x = lerp(velocity.x, main_vars.speed * direction, 0.05)
	
	var drop = func drop():
		if velocity.y < MAX_GRAVITY: # Checks and adjusts the current gravity
			velocity.y += main_vars.gravity
			main_vars.gravity += 1
	#endregion
	
	## All of the different actions possible in the current state        dw                            ddddddd go here
	#region Main
	if Input.is_action_pressed("Jump") and is_on_floor(): # Checks if you are holding jump
		sprite.play("pre_jump") # Plays the crouching animation for anticipation
		
		if main_vars.jump_power < MAX_JUMP: # Checks if jump power is maxed out, and if not increases it
			main_vars.jump_power += main_vars.jump_increase
		
		velocity.x = 0 # Dissables the ability to move during pre_jumps
	
	elif Input.is_action_just_released("Jump") and is_on_floor(): # Plays as soon as you release the jump
		sprite.play("jump") # Plays the jump animtation
		velocity.y = -main_vars.jump_power # Sets the upward velocity to jumping heights
	
	if Input.is_action_pressed("Jump") and not is_on_floor() and velocity.y > 0: # Checks if you are mid jump and holding
		velocity.y = main_vars.glide_gravity
		sprite.play("glide")
		air_movement.call()
		
		turn()
	
	# Checks if you are mid jump and falling
	elif (not Input.is_action_pressed("Jump") and not is_on_floor() or Input.is_action_pressed("Jump") and not is_on_floor() and velocity.y <= 0):
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
	if is_on_floor() and main_vars.gravity != 0:
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
		velocity.y = main_vars.climbing_speed * input ## Sets the Velocity to input
		sprite.play("climb")
	
	else:
		sprite.play("climb")
		sprite.stop()
		velocity.y = 0
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if Input.is_action_just_pressed("Jump"):
		velocity.x = main_vars.jump_power * get_sprite_rotation() * -1
		velocity.y = -main_vars.jump_power / 2
		sprite.flip_h = not sprite.flip_h
		sprite.play("fall")
		switch(States.CLIMB, States.AIR)
	
	if is_on_floor():
		position.x += 5 * get_sprite_rotation() * -1
		switch(States.CLIMB, States.GROUND)
	
	elif wall_detector.touching_wall() == false:
		switch(States.CLIMB, States.AIR)
	
	if edge_detector.on_edge():
		position.x += 20 * get_sprite_rotation()
		position.y -= 20
		velocity = Vector2(0,0)
		switch(States.CLIMB, States.GROUND)
	#endregion

func ram():
	
	#region Main
	if Input.is_action_pressed("Ram"):
		velocity.x = (lerpf(velocity.x,  float(main_vars.speed * 2 * get_sprite_rotation()), 0.01))
		sprite.play("ram")
	#endregion
	
	#region Exits
	if not Input.is_action_pressed("Ram"):
		velocity.x = 0
		switch(States.RAM, States.GROUND)
	
	if bump_detectors.bumped():
		velocity.x = main_vars.speed * 2 * get_sprite_rotation() * -1
		velocity.y = -main_vars.jump_power * 1.5
		switch(States.RAM, States.AIR)
	
	if not is_on_floor():
		switch(States.RAM, States.AIR)
	#endregion


## --- Helper Functions ---
func move():
	var direction = Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = main_vars.speed * direction
	else:
		velocity.x = 0

func turn():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func get_sprite_rotation():
	if sprite.flip_h == false:
		return 1
	else:
		return -1

func switch(old_state, new_state):
	if old_state == States.GROUND and new_state == States.AIR:
		current_state = new_state
	
	elif old_state == States.AIR and new_state == States.GROUND:
		sprite.play("pre_jump")
		var current_gravity = main_vars.gravity
		
		reset_main_vars()
		
		current_state = States.EMPTY
		
		velocity.x = 0
		
		await get_tree().create_timer(current_gravity/2500).timeout
		
		current_state = new_state
	
	elif old_state == States.CLIMB and new_state == States.AIR:
		reset_main_vars()
		
		current_state = new_state
	
	else:
		current_state = new_state

func reset_main_vars():
	var keys = main_vars.keys()
	
	for i in main_vars.size():
		main_vars[keys[i]] = main_var_reset[i]
