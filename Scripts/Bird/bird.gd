extends CharacterBody2D

const BLUE = preload("res://Recourses/Birds/Blue.tres")
const GREEN = preload("res://Recourses/Birds/Green.tres")
const PINK = preload("res://Recourses/Birds/Pink.tres")
const RED = preload("res://Recourses/Birds/Red.tres")
const WHITE = preload("res://Recourses/Birds/White.tres")

@onready var sprite = $Sprite

var positionY = 0

var fly_speed = Vector2(0, 0)

func _ready():
	position.y = positionY
	
	prints(name, position)
	
	var color = randi_range(0, 4)
	match color:
		0:
			sprite.sprite_frames = BLUE
		1:
			sprite.sprite_frames = GREEN
		2:
			sprite.sprite_frames = PINK
		3:
			sprite.sprite_frames = RED
		4:
			sprite.sprite_frames = WHITE


func _physics_process(_delta):
	move_and_slide()


func _on_area_2d_body_entered(body):
	run(body)
	print(body.name)

func _on_area_2d_area_entered(area):
	run(area)
	print(name, " is following another bird")

func run(detected):
	var run_rotation = 0
	
	if detected.position.x < position.x:
		run_rotation = 1
		sprite.flip_h = true
	else:
		run_rotation = -1
	
	sprite.play("fly")
	
	velocity.y = randf_range(300, 700) * -1
	velocity.x = randf_range(300, 700) * run_rotation
	
	
	$PlayerDetector.set_collision_layer_value(1, true)
