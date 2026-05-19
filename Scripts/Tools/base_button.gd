extends Button

class_name Base_Button

@export var func_parent : Node

var original_size = custom_minimum_size

var sizer : Tween

func _ready():
	visible = false
	
	await get_tree().create_timer(0.05).timeout
	
	if func_parent == null:
		func_parent = get_parent()
	
	visible = true
	
	if disabled == false:
		pressed.connect(has_pressed)
		mouse_entered.connect(mouse_hover)
		mouse_exited.connect(mouse_gone)
	

func has_pressed():
	func_parent.button_pressed(name)

func mouse_hover():
	sizer = get_tree().create_tween()
	sizer.tween_property(self, "custom_minimum_size", Vector2(original_size.x, original_size.y * 2), 0.05)

func mouse_gone():
	sizer = get_tree().create_tween()
	sizer.tween_property(self, "custom_minimum_size", original_size, 0.05)
