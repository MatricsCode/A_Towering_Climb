extends StaticBody2D

@onready var sprite = $Sprite2D
@export var level_height : float = 0.0

func _ready():
	GlobalScript.level_height = level_height
	
	#GlobalScript.important_positions[position] = 4
	
	var flip = randi_range(0, 1)
	if flip == 1:
		sprite.flip_h = true

func _on_area_2d_body_entered(body):
	if Networking.host:
		_won.rpc(body)

@rpc("authority", "call_local", "reliable")
func _won(body : Player):
	Signals.lobby_finished_game.emit(body)
	Signals.vignette.emit(0.5,1)
	await get_tree().create_timer(0.5).timeout
	Signals.lobby_return_to_lobby.emit()
