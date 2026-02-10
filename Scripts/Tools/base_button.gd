extends Button

class_name Base_Button

@export var parent : Node

var original_size = custom_minimum_size

var sizer : Tween

func _ready():
	pressed.connect(has_pressed)
	mouse_entered.connect(mouse_hover)
	mouse_exited.connect(mouse_gone)
	

func has_pressed():
	parent.button_pressed(name)

func mouse_hover():
	sizer = get_tree().create_tween()
	sizer.tween_property(self, "custom_minimum_size", Vector2(original_size.x, original_size.y * 2), 0.05)

func mouse_gone():
	sizer = get_tree().create_tween()
	sizer.tween_property(self, "custom_minimum_size", original_size, 0.05)
