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

var main_var_reset = [] ## The Array, getting auto-assigned in the ready function the values of main_vars

## --- Nodes ---
@onready var cam = $Camera2D 
@onready var sprite = $Sprite
@onready var ground_detector = $GroundDetector


## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scene
	
	cam.enabled = is_multiplayer_authority() ## Checks if you are this player and grants/denies you the camera from this
	
	current_state = States.GROUND ## Autoloads the normal state into the player
	
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
	#region Main
	if velocity.x != 0:
		sprite.play("walk")
	elif velocity.x == 0:
		sprite.play("idle")
	
	move()
	turn()
	#endregion
	
	#region Exits
	if Input.is_action_pressed("Jump"):
		switch(States.GROUND, States.AIR)
	#endregion

func air():
	#region Main
	if Input.is_action_pressed("Jump") and ground_detector.is_colliding():
		sprite.play("pre_jump")
		
		if main_vars.jump_power < MAX_JUMP:
			main_vars.jump_power += main_vars.jump_increase
			main_vars.jump_increase += 1
		
		velocity.x = 0
	elif Input.is_action_just_released("Jump") and ground_detector.is_colliding():
		sprite.play("jump")
		velocity.y = -main_vars.jump_power
		return
	
	if velocity.y > 0:
		sprite.play("fall")
	
	if not ground_detector.is_colliding() and velocity.y < MAX_GRAVITY:
		velocity.y += main_vars.gravity
		main_vars.gravity += 0.5
		move()
		turn()
	#endregion
	
	
	#region Exits
	if ground_detector.is_colliding() and main_vars.gravity != 0:
		switch(States.AIR, States.GROUND)
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
