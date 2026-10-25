extends Node

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D

@export var ground : Node
@export var air : Node
@export var climb : Node
@export var pause : Node

func _physics_process(delta):
	if player.current_state == player.States.GROUND:
		_anim_ground()
	elif player.current_state == player.States.AIR:
		_anim_air()
	elif player.current_state == player.States.CLIMB:
		_anim_climb()
	elif player.current_state == player.States.PAUSE:
		_anim_pause()

func _anim_ground():
	if player.velocity.x != 0:
		sprite.play("walk")
	elif player.velocity.x == 0:
		sprite.play("idle")
func _anim_air():
	if player.velocity.y > 10:
		sprite.play("fall") # Plays the fall animation if you are traveling downward
	elif player.velocity.y < -10:
		sprite.play("jump")# Plays the jump animation if you are traveling upward
	else:
		sprite.play("idle")
func _anim_climb():
	if player.velocity.y != 0:
		sprite.play("climb")
	
	else:
		sprite.play("climb")
		sprite.stop()
func _anim_pause():
	pass
