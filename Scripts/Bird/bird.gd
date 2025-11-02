extends CharacterBody2D

const BLUE = preload("res://Recourses/Birds/Blue.tres")
const GREEN = preload("res://Recourses/Birds/Green.tres")
const PINK = preload("res://Recourses/Birds/Pink.tres")
const RED = preload("res://Recourses/Birds/Red.tres")
const WHITE = preload("res://Recourses/Birds/White.tres")

@onready var sprite = $Sprite

var positionY = 0

var fly_speed = Vector2(0, 0)

var push_force = 5

func _ready():
	position.y = positionY
	
	$Switch_bird_detection_side.wait_time = randf_range(0, 3)
	$Switch_bird_detection_side.start()
	
	$BirdDetector.position.x += randf_range(-5, 5)
	$BirdDetector.target_position.x += randf_range(-5, 5)
	
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
	if $BirdDetector.is_colliding():
		$BirdDetector.get_collider().velocity.x = push_force * (position.x - $BirdDetector.get_collider().position.x) * -1
	
	velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	run(body)

func _on_area_2d_area_entered(area):
	run(area)

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
	
	
	#$PlayerDetector.set_collision_layer_value(1, true)


func _on_switch_bird_detection_side_timeout():
	
	$BirdDetector.position.x *= -1
	$BirdDetector.target_position.x *= -1
	
	$Switch_bird_detection_side.wait_time = randf_range(2, 15)
	$Switch_bird_detection_side.start()
