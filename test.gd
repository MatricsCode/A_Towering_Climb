extends CharacterBody2D

@onready var wall_detector = $WallDetectors

func _physics_process(delta):
	move_and_slide()
	
	if wall_detector.touching_wall():
		set_collision_layer_value(2,true)
	else:
		set_collision_layer_value(2,false)
