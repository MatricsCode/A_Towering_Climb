extends Camera2D

func _ready():
	make_current()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 0), GlobalScript.countdown_timer)
