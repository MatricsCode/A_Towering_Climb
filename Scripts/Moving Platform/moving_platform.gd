extends StaticBody2D

@export var speed := 10

@export var position1 := Vector2.ZERO
@export var position2 := Vector2.ZERO

var chosen_position = Vector2.ZERO

func _ready():
	position = position1

func _physics_process(delta):
	if position == position1:
		tween(position2)
	elif position == position2:
		tween(position1)

func tween(pos):
	var position_change = create_tween()
	position_change.tween_property(self, "position", pos, speed)
