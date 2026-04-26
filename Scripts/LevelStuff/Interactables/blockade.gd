extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var area = $Area2D
@onready var collision = $CollisionShape2D

var target = null

func _ready():
	timer.wait_time = randf_range(1, 5)
	timer.start()

func _on_area_2d_body_entered(body):
	if body.velocity.x > 1000 or body.velocity.x < -1000:
		body.shaking_camera = 20
		collision.position.y = 1000
		timer.stop()
		sprite.play("broken")
		$Area2D/CollisionShape2D2.queue_free()
		
		await get_tree().create_timer(0.2).timeout
		
		body.shaking_camera = 0


func _on_timer_timeout():
	sprite.play("default")
	timer.wait_time = randf_range(1, 10)
	timer.start()
