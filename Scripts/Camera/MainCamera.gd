extends Node2D

@onready var cam = $Camera2D

enum States {BOUNCING, FOLLOWING_PLAYER, FOLLOWING_WINNER}
var current_state = States.BOUNCING

var bouncing_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.lobby_start_game.connect(_start_animation)

func _physics_process(_delta):
	match current_state:
		States.BOUNCING:
			_bouncing()
		States.FOLLOWING_PLAYER:
			_following_player()

func _bouncing():
	position.x += 1
	position.y = -10000 + sin(bouncing_time) * 100
	bouncing_time += 0.01
	cam.zoom = Vector2(1 + cos(bouncing_time/2) * 0.1, 1 + cos(bouncing_time/2) * 0.1)
func _following_player():
	pass

func _start_animation():
	var movement = get_tree().create_tween()
	
	current_state = States.FOLLOWING_PLAYER
	
	movement.set_ease(Tween.EASE_IN_OUT)
	movement.set_parallel()
	movement.tween_property(cam, "zoom", Vector2(0.5,0.5), 1.5)
	movement.tween_property(self, "position", Vector2(0,get_window().size.y*-1), 3)
