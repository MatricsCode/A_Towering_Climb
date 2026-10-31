extends Node

const CLIMB_SFX = preload("res://Sound Effects/Climb.mp3")

signal switch(new_state, additional)

@export var player : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D

var friction := 0.1
var current := false
var sliding := false

func _ready():
	detectors.on_ground.connect(func(on_ground):
		if !current or !on_ground:
			return
		switch.emit(player.States.GROUND, "Finished"))
	detectors.on_wall.connect(func(on_wall):
		if !current or on_wall:
			return
		switch.emit(player.States.AIR, "Fall"))
	detectors.on_edge.connect(func(on_edge):
		if !current or on_edge:
			return
		switch.emit(player.States.GROUND, "OnEdge"))

func _physics_process(_delta):
	if player.current_state != player.States.CLIMB:
		current = false
		return
	else:
		current = true
	
	if sliding:
		return
	
	player.velocity.x = 0
	
	_climb()

func _climb():
	## All of the different actions possible in the current state go here
	#region Main
	var direction = Input.get_axis("Up", "Down") ## Accesses the current input
	
	if direction != 0:
		player.velocity.y = player.main_vars.climbing_vars.climbing_speed * direction
		sprite.play("climb")
	
	else:
		sprite.play("climb")
		sprite.stop()
		player.velocity.y = 0
	
	if sprite.frame == 1 or sprite.frame == 3:
		player._play_sound(CLIMB_SFX)
	#endregion
	
	## All of the different ways of exiting the current state go here
	#region Exits
	#if not player.is_on_wall_only():
		#switch.emit(player.States.GROUND, "LedgeClimb")
	#
	if Input.is_action_pressed("Jump"):
		switch.emit(player.States.AIR, "Jump")
	#
	#if player.is_on_floor():
		#switch.emit(player.States.GROUND, "Finished")
	#
	#elif wall_detectors.touching_wall() == false:
		#switch.emit(player.States.AIR, "NoWall")
	#endregion

func _slide(fall_speed):
	player.velocity.y = fall_speed
	player.velocity.x = 0.0
	sliding = true
	
	var tweener = get_tree().create_tween()
	var time = fall_speed / 10800.0
	tweener.tween_property(player, "velocity", Vector2.ZERO, time)
	
	await tweener.finished
	
	sliding = false
