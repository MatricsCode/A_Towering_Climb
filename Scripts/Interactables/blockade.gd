extends Interactable

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var area = $Area2D
@onready var collision = $CollisionShape2D

var glass = false

func interactable_ready():
	var turn_glass = 0#randi_range(0,2)
	if turn_glass == 0:
		glass = true
	
	if glass:
		sprite.play("default_glass")
	
	timer.wait_time = randf_range(1, 5)
	timer.start()

func _on_area_2d_body_entered(body):
	if check_abilities(body.ID, "Repair"):
		if glass:
			pass
		else:
			sprite.play("default_brick")
			
			timer.wait_time = randf_range(1, 5)
			timer.start()
			
			set_collision_layer_value(2,true)
			
			area.monitoring = true
	
	elif check_abilities(body.ID, "Punch") and glass == true and Input.is_action_pressed("Ability"):
		body.shaking_camera = 10
		
		destroy()
		
		await get_tree().create_timer(0.2).timeout
	
		body.shaking_camera = 0

	elif check_abilities(body.ID, "Ram") and glass == false and Input.is_action_pressed("Ability"):
		body.shaking_camera = 20
		
		destroy()
		
		await get_tree().create_timer(0.2).timeout
	
		body.shaking_camera = 0


func destroy():
	set_collision_layer_value(2,false)
	
	timer.stop()
	if not glass:
		sprite.play("broken_brick")
	else:
		sprite.play("broken_glass")

func _on_timer_timeout():
	if not glass:
		sprite.play("default_brick")
	else:
		pass
	
	timer.wait_time = randf_range(1, 10)
	timer.start()
