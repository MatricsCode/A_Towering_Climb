extends StaticBody2D

@export var health = 50

func _on_area_2d_body_exited(body):
	if body.is_in_class("player"):
		if body.velocity.x > 0:
			health -= int(body.velocity.x / 48)
		else:
			health += int(body.velocity.x / 48)
