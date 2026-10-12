extends Node2D

var bouncing := true

@onready var cam = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.lobby_start_game.connect(_start_animation)

func _physics_process(delta):
	if bouncing:
		position.x += 0.1
		position.y += sin(delta*2) * 10

func _start_animation():
	var movement = get_tree().create_tween()
	
	movement.set_ease(Tween.EASE_IN_OUT)
	movement.set_trans(Tween.TRANS_ELASTIC)
	movement.tween_property(self, "position", Vector2.ZERO, 3)
	movement.tween_property(cam, "zoom", Vector2.ONE, 3)
