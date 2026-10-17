extends Node

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D

func _physics_process(_delta):
	if player.current_state == player.States.AIR:
		_main()


func _main():
	#region Functions
	var air_movement = func air_movement():
		var direction = Input.get_axis("Left", "Right")
		
		if (direction == player.main_vars.air_vars.movement_direction and 
			player.main_vars.air_vars.movement_direction != 0 and 
			player.velocity.x * direction <= player.main_vars.ground_vars.speed):
				player.velocity.x = player.main_vars.ground_vars.speed * direction
		
		elif direction != player.main_vars.air_vars.movement_direction and direction != 0:
			player.velocity.x = lerp(player.velocity.x, 
				player.main_vars.ground_vars.speed * direction, 0.1)
		
		elif direction == 0 and player.velocity.x != 0:
			player.velocity.x = lerpf(player.velocity.x, 0.0, 0.005)
	
	## Variable Jump Height is in Physiscs Process!
	
	var drop = func drop():
		if player.velocity.y < player.MAX_GRAVITY: # Checks and adjusts the current gravity
			player.velocity.y += player.main_vars.air_vars.gravity
			player.main_vars.air_vars.gravity += player.main_vars.air_vars.gravity_increase
			player.main_vars.air_vars.gravity_increase += 0.1
		
		if player.velocity.y > -300 and player.velocity.y < 0:
			player.velocity.y = 100
	#endregion
	
	## All of the different actions possible in the current state go here
	#region Main
	
	## Checks if you are mid jump and falling
	if not player.is_on_floor(): #elif not is_on_floor():
		air_movement.call()
		
		turn()
		drop.call()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if player.is_on_floor():
		player.switch(player.States.AIR, player.States.GROUND)
	
	if player.wall_detector.touching_wall():
		player.position.y -= 5
		player.switch(player.States.AIR, player.States.CLIMB)
	#endregion

func _animation():
	if not player.is_on_floor(): #elif not is_on_floor():
		if player.velocity.y > 0:
			sprite.play("fall") # Plays the fall animation if you are traveling downward
		elif player.velocity.y < 0:
			sprite.play("jump")# Plays the jump animation if you are traveling upward
func turn():
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true
