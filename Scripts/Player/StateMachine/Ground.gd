extends Node

const WALK_SFX = preload("res://Sound Effects/Walking.mp3")

signal switch(new_state, additional)

@export_group("Variables")
@export_range(0.0,0.1,0.01) var wait_time 

@export_group("Nodes")
@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

var coyote_timer : Timer

var current := false

func _ready():
	#detectors.on_ground.connect(func(is_true):
		#if !current or is_true:
			#switch.emit(player.States.AIR, "Fall"))
	detectors.on_wall.connect(func(is_true):
		if !current or !is_true:
			return
		
		switch.emit(player.States.CLIMB))

func _physics_process(_delta):
	if player.current_state != player.States.GROUND:
		current = false
		return
	else:
		current = true
	
	_ground()

func _ground():
	_move()
	_turn()
	
	player.velocity.y = 10 #player.main_vars.air_vars.gravity
	
	if sprite.frame == 1 or sprite.frame == 5:
		player._play_sound(WALK_SFX)
	
	## All of the different ways of exiting the current state go her
	if Input.is_action_pressed("Jump"):
		switch.emit(player.States.AIR, "Jump")
	
	#if not player.is_on_floor():# and not Input.is_action_pressed("Jump"):
		#await get_tree().create_timer(0.1).timeout
		#switch.emit(player.States.AIR, "Fall")
	
	#elif not player.is_on_floor() and Input.is_action_pressed("Jump"):
		#switch.emit(player.States.AIR, "Jump")

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
