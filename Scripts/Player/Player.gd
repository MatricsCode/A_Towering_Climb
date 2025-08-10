extends CharacterBody2D
class_name player

## --- Enums ---
enum States {GROUND, AIR, CLIMB, RAM}

## --- Variables ---
var current_state

var speed = 300 ## Determins how much the player can move in one frame
var jump_power = -500 ## Determins the height of the players jump

## --- Nodes ---
@onready var cam = $Camera2D 
@onready var sprite = $Sprite


## --- Inbuilt functions ---
func _ready(): ## Runns as soon as the player is loaded into the scene
	cam.enabled = is_multiplayer_authority() ## Checks if you are this player and grants/denies you the camera from this
	current_state = States.GROUND ## Autoloads the normal state into the player

func _physics_process(delta):  ## Runns every physics frame
	if not is_multiplayer_authority():
		return ## Checks if you are this player, and grants/denies you control acordingly
	
	match current_state:
		States.GROUND:
			ground()
	
	turn()
	
	move_and_slide()


## --- Self made functions ---
func ground():
	var direction = Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = speed * direction
		sprite.play("walk")
	else:
		velocity.x = 0
		sprite.play("idle")

## --- Helper Functions ---
func turn():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
