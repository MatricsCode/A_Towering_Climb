extends StaticBody2D

class_name Interactable

var interacted = false
var player

func interact(body):
	player = body
	interacted = true
	action()

func action():
	pass
