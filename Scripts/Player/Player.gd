extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var cam = $Camera2D

func _ready():
	cam.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	#
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
