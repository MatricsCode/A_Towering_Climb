extends StaticBody2D

signal won(player)

func _on_area_2d_body_entered(body):
	get_tree().paused = true
	won.emit(body.name)
