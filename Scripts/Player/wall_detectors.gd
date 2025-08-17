extends Node2D


func touching_wall():
	if $WallDetector1.is_colliding() or $WallDetector2.is_colliding():
		return true
	else:
		return false
