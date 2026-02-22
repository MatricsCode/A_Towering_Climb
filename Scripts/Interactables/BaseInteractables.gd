extends StaticBody2D

class_name Interactable

## 0 is Glide, 1 is Sky Lift Key, 2 is Climbers Hook, 3 is Drum Key, 4 is Ram
@export var activator : String
@export var target : Node

var passer
var interacted = false
var player

func interact(body):
	player = body
	interacted = true
	action()

func action():
	pass

func entered(has_entered : bool):
	pass
