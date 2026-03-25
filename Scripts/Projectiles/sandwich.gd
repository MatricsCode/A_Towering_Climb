extends StaticBody2D

var direction = 0
var speed = 5
var gravity = -1
var rotation_speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	speed += randf_range(-3.0,3.0)
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	
	$AnimatedSprite2D.animation = str(randi_range(1,9))
	
	rotation_speed += randf_range(1, 2)
	
	#$Area2D.monitoring = true

func _process(delta):
	print(direction)
	
	rotation_degrees += rotation_speed * direction
	
	position.x += speed * direction 
	position.y -= gravity
	
	gravity -= 0.1


#func _on_area_2d_body_entered(body):
	##if body.is_in_group("player"):
	#body.velocity.x = 500 * direction
	#body.velocity.y = -250
	#
	#queue_free()
