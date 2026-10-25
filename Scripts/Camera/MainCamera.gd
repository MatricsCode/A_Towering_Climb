extends Node2D

@onready var cam = $Camera2D

enum States {BOUNCING, STARTING_ANIMATION, FOLLOWING_PLAYER}
var current_state = States.BOUNCING

var bouncing_time = 0

var movement : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.lobby_start_game.connect(_start_animation)

func _physics_process(_delta):
	match current_state:
		States.BOUNCING:
			_bouncing()
		States.STARTING_ANIMATION:
			pass
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
	current_state = States.STARTING_ANIMATION
	
	movement = get_tree().create_tween()
	movement.set_parallel()
	movement.set_ease(Tween.EASE_OUT)
	movement.tween_property(self, "position", Vector2(0, -7000), 2)
	movement.tween_property(cam, "zoom", Vector2(0.2, 0.2), 2)
	
	await get_tree().create_timer(2.5).timeout
	movement.kill()
	movement = get_tree().create_tween()
	movement.set_ease(Tween.EASE_OUT)
	movement.tween_property(self, "position", Vector2(0,0), 2)
	
	await get_tree().create_timer(2.2).timeout
	movement.kill()
	movement = get_tree().create_tween()
	movement.set_ease(Tween.EASE_OUT)
	movement.tween_property(self, "position", Vector2(0,-7000), 2)
	
	await get_tree().create_timer(2.2).timeout
	movement = get_tree().create_tween()
	movement.set_parallel()
	movement.set_ease(Tween.EASE_OUT)
	movement.tween_property(self, "position", Vector2(0,0), 2)
	movement.tween_property(cam, "zoom", Vector2(0.6,0.6), 2)
