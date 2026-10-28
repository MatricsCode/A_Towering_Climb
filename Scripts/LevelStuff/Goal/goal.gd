extends StaticBody2D

@onready var sprite = $Sprite2D

func _ready():
	GlobalScript.important_positions[position] = 4
	
	var flip = randi_range(0, 1)
	if flip == 1:
		sprite.flip_h = true

func _on_area_2d_body_entered(body):
	if Networking.host:
		_won.rpc(body)

@rpc("authority", "call_local", "reliable")
func _won(body : Player):
	Signals.lobby_finished_game.emit(body)
