extends abilitys

func _ready():
	overide()

func _physics_process(delta):
	player.velocity.x = 0
	
	var direction = Input.get_axis("Left", "Right")
	player.position.x += 0.5 * direction
	if direction != 0:
		player.get_child(0).play("walk")
	else:
		player.get_child(0).play("idle")
	
	if direction > 0:
		player.get_child(0).flip_h = false
	elif direction < 0:
		player.get_child(0).flip_h = true
	
	player.main_vars.gravity = 1
