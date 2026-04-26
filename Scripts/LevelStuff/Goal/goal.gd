extends StaticBody2D

@onready var sprite = $Sprite2D

func _ready():
	GlobalScript.important_positions[position] = load("res://Art/Markers/Goal.png")
	
	var flip = randi_range(0, 1)
	if flip == 1:
		sprite.flip_h = true

func _on_area_2d_body_entered(body):
	GlobalScript.winner.emit(body.name)
	get_tree().paused = true
	queue_free()
