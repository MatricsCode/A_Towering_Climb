extends abilitys

#var punching = false
#var punch_force = 0
#
#var grip : Tween
#var timer : Timer
#var punch_area : Area2D
#
#func _ready():
	#timer = add_timer(1, false, increase_punch_strength)
	#punch_area = add_area_2D(1, area1_colliding)
#
#func _physics_process(delta):
	#if Input.is_action_pressed("Ability") and player.current_state == activation_state and not in_action and not punching:
		#overide()
		#player.velocity.x = 0
		#increase_punch_strength()
	#
	#if Input.is_action_just_released("Ability") and in_action and ! punching:
		#timer.stop()
		#punch()
	#
	#if player.is_on_wall() and in_action:
		#punching = false
		#grip.kill()
		#player.velocity = Vector2(0,0)
		#punch_force = 0
		#reset()
	#
	#punch_area.position.x = player.position.x + 75 * player.get_sprite_rotation()
	#punch_area.position.y = player.position.y
	#
#
#func increase_punch_strength():
	#if Input.is_action_pressed("Ability") and in_action and punch_force < 3:
		#punch_force += 1
		#player.camera_zoom(0.5 + punch_force / 5, 0.9)
		#timer.start()
	#else:
		#punch()
#
#func punch():
	#player.position.y -= 1
	#player.velocity.x = 2000 * punch_force * player.get_sprite_rotation()
	#punching = true
	#
	#grip = get_tree().create_tween()
	#grip.tween_property(player, "velocity", Vector2(0,0), 0.2 * punch_force).set_ease(Tween.EASE_OUT)
	#
	#player.camera_zoom(0.5, 0.2 * punch_force)
	#
	#await grip.finished
	#
	#punching = false
	#grip.kill()
	#player.velocity = Vector2(0,0)
	#punch_force = 0
	#reset()
#
#func area1_colliding(body):
	#if in_action:
		#body.velocity = Vector2(1000000000 * player.get_sprite_rotation(), -700)
