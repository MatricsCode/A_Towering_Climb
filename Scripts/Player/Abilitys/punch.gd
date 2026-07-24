extends abilitys

var area1
var area2

var timer 

var grip : Tween

func _ready():
	timer = Timer.new()
	add_child(timer)
	
	grip = get_tree().create_tween()
	
	area1 = add_area_2D(1)
	
	area1.body_entered.connect(area1_colliding)
	
	timer.timeout.connect(stop_punch)

func _physics_process(delta):
	print(player.velocity)
	
	if Input.is_action_pressed(input) and player.current_state == activation_state:
		overide()
		timer.start(0.2)
		player.velocity.x += 3000 * player.get_sprite_rotation()
	
	elif in_action and Input.is_action_pressed(input):
		grip.kill()
		grip = get_tree().create_tween()
		grip.tween_property(player, "velocity", Vector2.ZERO, 0.2)
	
	elif Input.is_action_just_released(input):
		in_action = false
	
	if grip.is_running() and in_action == false:
		grip.kill()
		grip = get_tree().create_tween()
		grip.tween_property(player, "velocity", Vector2.ZERO, 0.1)
		
		if player.velocity.x < 10 and player.velocity.x > -10:
			stop_punch()
	
	area1.position.x = player.position.x + 75 * player.get_sprite_rotation()
	area1.position.y = player.position.y
	

func area1_colliding(body):
	if in_action:
		body.velocity = Vector2(100 * player.get_sprite_rotation(), -700)
	stop_punch()

func stop_punch():
	grip.stop()
	reset()
	player.velocity = Vector2(0,0)
	timer.stop()
