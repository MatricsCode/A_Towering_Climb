extends Button
class_name HoverButton

var time := 1.0

var hovering := false

func _ready():
	time = randf_range(-100.0,100.0)
	pivot_offset_ratio = Vector2(0.5,0.5)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _physics_process(delta):
	if !hovering:
		time += 1.0
		rotation_degrees = cos(time/20) * (size.x / 300)

func _mouse_entered():
	hovering = true
	time = 0
	var tweener = get_tree().create_tween()
	if rotation_degrees > 0:
		rotation_degrees = -25
	else:
		rotation_degrees = 25
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "rotation_degrees", 0, 0.05)
	tweener.tween_property(self, "scale", Vector2(1.3,1.3), 0.05)
	tweener.tween_property(self, "custom_minimum_size", Vector2(1.3,1.3), 0.05)
func _mouse_exited():
	hovering = false
	time += randf_range(-100.0,100.0)
	var tweener = get_tree().create_tween()
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "scale", Vector2(1,1), 0.05)
	tweener.tween_property(self, "custom_minimum_size", Vector2(1,1), 0.05)
