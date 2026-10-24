extends Node2D

signal on_ground(is_true : bool)
signal on_wall(is_true : bool)
signal on_edge(is_true : bool)

@export var left_ground : RayCast2D
@export var right_ground : RayCast2D
@export var left_wall : RayCast2D
@export var right_wall : RayCast2D
@export var left_edge : RayCast2D
@export var right_edge : RayCast2D

var is_on_ground := false
var is_on_wall := false
var is_on_edge := false

func _physics_process(_delta):
	_on_ground()
	_on_wall()
	_on_edge()

func _on_ground():
	var current_situation : bool
	
	if left_ground.is_colliding() or right_ground.is_colliding():
		current_situation = true
	else:
		current_situation = false
	
	if current_situation != is_on_ground:
		on_ground.emit(current_situation)
func _on_wall():
	var current_situation : bool
	
	if left_wall.is_colliding() or right_wall.is_colliding():
		current_situation = true
	else:
		current_situation = false
	
	if current_situation != is_on_wall:
		on_wall.emit(current_situation)
func _on_edge():
	var current_situation : bool
	
	if left_edge.is_colliding() or right_edge.is_colliding():
		current_situation = true
	else:
		current_situation = false
	
	if current_situation != is_on_edge:
		on_edge.emit(current_situation)
