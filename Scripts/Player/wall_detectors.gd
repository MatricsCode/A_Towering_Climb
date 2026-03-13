extends Node2D


func touching_wall(exact = false):
	if exact == false:
		if $WallDetector1.is_colliding() or $WallDetector2.is_colliding():
			return true
		else:
			return false
	else:
		if $WallDetector1.is_colliding():
			return -1
		elif $WallDetector2.is_colliding():
			return 1
		else:
			return 0
