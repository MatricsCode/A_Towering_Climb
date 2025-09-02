extends Node2D

var timer = 0

func _physics_process(delta):
	if Input.is_action_pressed("Ram") and get_parent().is_on_floor():
		timer += 1
		print(timer)
	else:
		timer = 0

func bumped():
	if $WallDetector1.is_colliding():
		if $WallDetector1.get_collider().is_in_group("Bumpable"):
			if timer < 50:
				$WallDetector1.get_collider().bumped(1)
			elif timer < 150:
				$WallDetector1.get_collider().bumped(2)
			else:
				$WallDetector1.get_collider().bumped(3)
		
		return true
	
	elif $WallDetector2.is_colliding():
		
		if $WallDetector2.get_collider().is_in_group("Bumpable"):
			if timer < 50:
				$WallDetector2.get_collider().bumped(1)
			elif timer < 150:
				$WallDetector2.get_collider().bumped(2)
			else:
				$WallDetector2.get_collider().bumped(3)
	
	
		return true
	
	else:
		return false
