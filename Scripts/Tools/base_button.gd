extends Button

class_name Base_Button

var parent = Node

func _ready():
	pressed.connect(has_pressed)

func has_pressed():
	parent.button_pressed(name)
