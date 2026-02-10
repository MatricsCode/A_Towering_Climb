extends StaticBody2D

class_name Interactable

## 0 is Glide, 1 is Sky Lift Key, 2 is Climbers Hook, 3 is Drum Key, 4 is Ram
@export_range(0, 10, 1) var activator

var passer
var interacted = false
var player

func interact(body):
	player = body
	interacted = true
	action()

func action():
	pass
