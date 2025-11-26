extends StaticBody2D

func _ready():
	GlobalScript.goal_position_y = position.y

func _on_area_2d_body_entered(body):
	GlobalScript.winner.emit(body.name)
	get_tree().paused = true
	queue_free()
