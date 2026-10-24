extends Node

const WALK_SFX = preload("res://Sound Effects/Walking.mp3")

signal switch(new_state, additional)

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D

func _physics_process(_delta):
	if player.current_state == player.States.GROUND:
		_main()

func _main():
	_animation()
	_move()
	_turn()
	
	if sprite.frame == 1 or sprite.frame == 5:
		player._play_sound(WALK_SFX)
	
	## All of the different ways of exiting the current state go her
	#if Input.is_action_pressed("Jump"):
		#switch.emit(player.States.AIR, "Jump")
	#
	#if not player.is_on_floor():# and not Input.is_action_pressed("Jump"):
		#await get_tree().create_timer(0.1).timeout
		#switch.emit(player.States.AIR, "Fall")
	
	#elif not player.is_on_floor() and Input.is_action_pressed("Jump"):
		#switch.emit(player.States.AIR, "Jump")
	
	elif player.is_on_wall():
		switch.emit(player.States.CLIMB)

func _animation():
	if player.velocity.x != 0:
		sprite.play("walk")
	elif player.velocity.x == 0:
		sprite.play("idle")
func _move():
	var direction = Input.get_axis("Left", "Right")
	if direction != 0:
		player.velocity.x = player.main_vars.ground_vars.speed * direction
	else:
		player.velocity.x = 0
func _turn():
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true
