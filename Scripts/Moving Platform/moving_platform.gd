extends StaticBody2D

@export var speed := 10

@export var position1 := Vector2.ZERO
@export var position2 := Vector2.ZERO

var chosen_position = Vector2.ZERO

@onready var label = $Label

var player = null

func _ready():
	position = position1

func _physics_process(delta):
	if Input.is_action_just_pressed("Interact") and label.visible == true:
		label.visible = false
		move()
		
	while position != position1 and position != position2: 
		player.position = position

func _on_area_2d_body_entered(body):
	label.visible = true
	player = body

func _on_area_2d_body_exited(body):
	label.visible = false
	player = null

func move():
	if position == position1:
		tween(position2)
	elif position == position2:
		tween(position1)

func tween(pos):
	var position_change = create_tween()
	position_change.tween_property(self, "position", pos, speed)
