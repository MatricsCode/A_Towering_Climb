extends abilitys

var can_throw = false
var counter = 0

func _physics_process(_delta):
	counter += 0.01
	
	if Input.is_action_pressed("Ability") and counter > 100 and player.current_state == activation_state:
		Signals.projectile.emit([preload("res://Scenes/Sandwich.tscn"), player.position, player._get_sprite_rotation()])
		can_throw = false
		counter = 0

func can_sandwich():
	var can_throw = true
