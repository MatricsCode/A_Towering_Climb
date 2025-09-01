extends StaticBody2D

var health = 5

func bumped(remaining_health):
	
	health -= remaining_health
	
	$Label.text = str(health)
	
	print("Bumped")
	
	if health <= 0:
		queue_free()
