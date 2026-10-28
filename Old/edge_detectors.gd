extends Node2D

func _on_edge():
	if $EdgeDetector1.is_colliding() or $EdgeDetector2.is_colliding():
		return true
	else:
		return false
