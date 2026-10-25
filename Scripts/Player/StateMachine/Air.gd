extends Node

signal switch(new_state, additional)

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

@export_range(0.01, 0.3,0.01) var wait_time : float
var clock := Timer

var fall_speed = 0

var coyote_timer : Timer

var current := false

func _ready():
	detectors.on_ground.connect(func(is_true : bool):
		if !current or !is_true:
			return
		switch.emit(player.States.GROUND, "Land"))
	detectors.on_wall.connect(func(is_true : bool):
		if !current or !is_true:
			return
		switch.emit(player.States.CLIMB, "WallHit"))
	
	
	
	#coyote_timer = Timer.new()
	#
	#add_child(coyote_timer)
	#coyote_timer.timeout.connect(func():
		#switch.emit(player.States.AIR, "Fall"))
	#coyote_timer.wait_time = wait_time
	#coyote_timer.one_shot = true

func _physics_process(_delta):
	if player.current_state != player.States.AIR:
		current = false
		return
	elif player.current_state == player.States.AIR:
		current = true
	
	_air()

func _air():
	if fall_speed < player.MAX_GRAVITY:
		fall_speed += player.main_vars.air_vars.gravity_increase
		player.main_vars.air_vars.gravity = fall_speed
	
	player.velocity.y = fall_speed

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
		
		_turn()
		drop.call()
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	if player.is_on_floor():
		switch.emit(player.States.GROUND)
	
	if player.wall_detector._touching_wall():
		player.position.y -= 5
		switch.emit(player.States.CLIMB)
	#endregion

func _coyote_time():
	coyote_timer.start()

func _turn():
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true
#func _jump():
	#player.velocity.y = -player.main_vars.air_vars.jump_strength
	#player.velocity.x = (player.main_vars.ground_vars.speed / 2) * player.get_sprite_rotation()
