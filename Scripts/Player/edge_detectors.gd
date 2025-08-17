extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_edge():
	if not $EdgeDetector1.is_colliding() and not $EdgeDetector2.is_colliding() and on_wall():
		return true
	else:
		return false

func on_wall():
	if $FloorDetector1.is_colliding() or $FloorDetector2.is_colliding():
		return true
	else:
		return false
