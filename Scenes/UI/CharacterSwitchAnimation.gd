extends Panel



var direction := 0

func _ready():
	sprite1.animation_finished.connect(_switch_anim)
	sprite2.animation_finished.connect(_switch_anim)

func _append_direction(set_direction := 0):
	direction += set_direction

func _switch_anim():
	pass
