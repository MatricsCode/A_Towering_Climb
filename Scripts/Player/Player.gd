extends CharacterBody2D
class_name player

## --- Enums ---
enum States {GROUND, AIR, CLIMB, RAM, EMPTY}

## --- Constants ---

const MAX_JUMP = 700
const MAX_GRAVITY = 5000

## --- Variables ---
var current_state

var main_vars = { ## Main ariables
	speed = 300, ## Determins how much the player can move in one frame
	jump_power = 500,  ## Determins the height of the players jump
	jump_increase = 1,
	gravity = 0, ## Determins at what speed the player falls down
}

var main_var_reset = [] ## The Array, gets auto-assigned in the ready function with the values of main_vars

## --- Nodes ---
@onready var cam = $Camera2D 
@onready var sprite = $Sprite

## --- Export Variables ---
@export var velocity2 = velocity ## Allows the Multiplayer Synchronizer to sync the velocity

## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scene
	
	cam.enabled = is_multiplayer_authority() ## Checks if you are this player and grants/denies you the camera from this
	
	current_state = States.AIR ## Autoloads the normal state into the player
	
	main_var_reset = main_vars.values() ## Loads all the values of main vars into main var reset, so that they are stored seperatly

func _physics_process(delta):  ## Runs every physics frame
	if not is_multiplayer_authority():
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	match current_state:
		States.GROUND:
			ground()
		States.AIR:
			air()
	
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
	elif not is_on_floor():
		switch(States.GROUND, States.AIR)
	#endregion

func air():
	## All of the different actions possible in the current state go here
	#region Main
	if Input.is_action_pressed("Jump") and is_on_floor(): # Checks if you are holding jump
		sprite.play("pre_jump") # Plays the crouching animation for anticipation
		
		if main_vars.jump_power < MAX_JUMP: # Checks if jump power is maxed out, and if not increases it
			main_vars.jump_power += main_vars.jump_increase
			main_vars.jump_increase += 1
		
		velocity.x = 0 # Dissables the ability to move during pre_jumps
	elif Input.is_action_just_released("Jump") and is_on_floor(): # Plays as soon as you release the jump
		sprite.play("jump") # Plays the jump animtation
		velocity.y = -main_vars.jump_power # Sets the upward velocity to jumping heights
	
	if velocity.y > 0:
		sprite.play("fall") # Plays the fall animation if you are traveling downward
	
	if not is_on_floor() and velocity.y < MAX_GRAVITY: # Checks and adjusts the current gravity
		velocity.y += main_vars.gravity
		main_vars.gravity += 0.5
		move()
		turn()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if is_on_floor() and main_vars.gravity != 0:
		switch(States.AIR, States.GROUND)
	#endregion
func climb():
	pass

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

func switch(old_state, new_state):
	if old_state == States.GROUND and new_state == States.AIR:
		current_state = new_state
	
	elif old_state == States.AIR and new_state == States.GROUND:
		sprite.play("pre_jump")
		reset_main_vars()
		
		current_state = States.EMPTY
		
		velocity.x = 0
		
		await get_tree().create_timer(0.2).timeout
		
		current_state = new_state

func reset_main_vars():
	var keys = main_vars.keys()
	
	for i in main_vars.size():
		main_vars[keys[i]] = main_var_reset[i]
