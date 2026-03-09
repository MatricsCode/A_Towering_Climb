extends CharacterBody2D

func _physics_process(delta):
	move_and_slide()
	
	if is_on_wall():
		print("Wall")
