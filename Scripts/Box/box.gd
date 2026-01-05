extends StaticBody2D

@export var health = 50

var destroyed_wall = preload("res://Art/Tilemap/Wall2.png")

func bumped(new_health):
	health -= new_health
	
	if health < 0:
		self_destruct()

func self_destruct():
	queue_free()
