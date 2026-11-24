extends StaticBody2D

@export var sprite : AnimatedSprite2D
@export var area : Area2D

const COLORS = ["Blue", "Green", "Red"]
var color : String

func _ready():
	color = COLORS[randi_range(0, COLORS.size()-1)]
	sprite.play(str(color, "Idle"))

func _physics_process(delta):
	pass







#@onready var sprite = $Sprite
#
#var fly_speed = Vector2(0, 0)
#var message_others : int
#
#func _ready():
	#message_others = randi_range(-3, 1)
	#
	#var twist = randi_range(0, 1)
	#
	#if twist == 0:
		#sprite.flip_h = true
	#
	#var color = randi_range(0, 4)
#
#
#func _physics_process(_delta):
	#move_and_slide()
#
#
#func _on_area_2d_body_entered(body):
	#run(body)
#
#func _on_area_2d_area_entered(area):
	#run(area)
#
#func run(detected):
	#var run_rotation = 0
	#
	#if detected.position.x < position.x:
		#run_rotation = 1
		#sprite.flip_h = true
	#else:
		#run_rotation = -1
	#
	#sprite.play("fly")
	#
	#velocity.y = randf_range(300, 700) * -1
	#velocity.x = randf_range(300, 700) * run_rotation
	#
	#if message_others == 1:
		#$PlayerDetector.set_collision_layer_value(1, true)
