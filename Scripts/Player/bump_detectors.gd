extends Node2D

func bumped():
	if $WallDetector1.is_colliding():
		
		if $WallDetector1.get_collider().is_in_group("Bumpable"):
			$WallDetector1.get_collider().bumped(get_parent().main_vars.ram_time + get_parent().main_vars.ram_damage)
		
		return true
	
	elif $WallDetector2.is_colliding():
		
		if $WallDetector2.get_collider().is_in_group("Bumpable"):
			$WallDetector2.get_collider().bumped(get_parent().main_vars.ram_time + get_parent().main_vars.ram_damage)
	
		return true
	
	else:
		return false
