extends Node

class_name abilitys

@export var activation_state = 0
@export var player : CharacterBody2D

var in_action = false

func overide():
	in_action = true
	get_parent().get_parent().overide(true)

func reset():
	in_action = false
	get_parent().get_parent().overide(false)

func add_timer(start_time : float, one_shot : bool, function : Callable):
	
	var timer = Timer.new()
	timer.wait_time = start_time
	timer.one_shot = one_shot
	timer.timeout.connect(function)
	
	add_child(timer)
	
	return timer

func add_area_2D(collision_mask : int, function : Callable):
	var scanner = Area2D.new()
	
	scanner.body_entered.connect(function)
	scanner.body_exited.connect(function)
	
	var hit_area = CollisionShape2D.new()
	
	hit_area.shape = RectangleShape2D.new()
	hit_area.position.y -= 50
	hit_area.debug_color = Color.BLACK
	
	add_child(scanner)
	
	scanner.set_collision_mask_value(1, false)
	scanner.set_collision_layer_value(1, false)
	
	scanner.set_collision_mask_value(collision_mask, true)
	
	scanner.add_child(hit_area)
	
	return scanner
