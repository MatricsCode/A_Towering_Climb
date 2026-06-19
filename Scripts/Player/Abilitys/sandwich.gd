extends abilitys

var can_throw = false
var count = 100

func _physics_process(delta):
	count -= 1
	
	if Input.is_action_pressed(input) and count < 1 and player.current_state == activation_state:
		count = 100
		GlobalScript.projectile.emit([preload("res://Scenes/Sandwich.tscn"), player.position, player.get_sprite_rotation()])
