extends Interactable

@export var health = 50

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _ready():
	timer.wait_time = randf_range(1, 5)
	timer.start()

func bumped():
		self_destruct()

func self_destruct():
	timer.stop()
	timer.queue_free()
	sprite.play("broken")
	
	set_collision_layer_value(1, false)


func _on_timer_timeout():
	sprite.play("default")
	timer.wait_time = randf_range(1, 10)
	timer.start()
