extends abilitys

var area = null
var speed = 0
var climbing_speed

func _ready():
	speed = player.main_vars_reset[0]
	climbing_speed = player.main_vars_reset[6]
	
	add_area_2D(25)
	area = get_child(0)

func _physics_process(delta):
	if area != null:
		area.position = player.position
	
	if player.current_state == activation_state and Input.is_action_pressed("Jump"):
		player.main_vars.ground_vars["speed"] = speed
		player.main_vars_reset[0] = speed
		
		player.main_vars.climbing_vars["speed"] = climbing_speed
		player.main_vars_reset[6] = climbing_speed


func area_interact(body):
	body.queue_free()
	
	player.main_vars.ground_vars["speed"] *= 1.2
	player.main_vars_reset[0] *= 1.2
	
	player.main_vars.climbing_vars["speed"] *= 1.2
	player.main_vars_reset[6] *= 1.2
