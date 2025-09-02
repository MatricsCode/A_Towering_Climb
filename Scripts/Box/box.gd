extends StaticBody2D

var health = 5

func bumped(remaining_health):
	
	health -= remaining_health
	
	if health <= 0:
		queue_free()
