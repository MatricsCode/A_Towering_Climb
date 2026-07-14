extends abilitys

var can_throw = false
var counter = 0

func _physics_process(delta):
	counter += 0.01
	
	if Input.is_action_pressed(input) and counter > 100 and player.current_state == activation_state:
		GlobalScript.projectile.emit([preload("res://Scenes/Sandwich.tscn"), player.position, player.get_sprite_rotation()])
		can_throw = false
		counter = 0

func can_sandwich():
	var can_throw = true
