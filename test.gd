extends CharacterBody2D

@onready var wall_detectors = $WallDetectors

func _physics_process(_delta):
	move_and_slide()
	
	if wall_detectors._touching_wall():
		set_collision_layer_value(2,true)
	else:
		set_collision_layer_value(2,false)
