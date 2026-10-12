extends Button
class_name HoverButton


func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	pass
func _mouse_exited():
	pass
