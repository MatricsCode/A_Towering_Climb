extends Node2D
class_name Interactable

@export_group("Main")
@export var activator : Script
@export var target : Node

@export_group("Nodes")
@export var area : Area2D
@export var sprite : AnimatedSprite2D

var players := []

func _ready():
	var check = func(body : Player): ## Checks if the player has the correct ability
		var player_stats : PlayerSource
		player_stats = body.player_source
		
		## This line just checks if any of the ability scripts of the player matches the activator
		if (player_stats.main_var == activator or
		 player_stats.passive_ability == activator or player_stats.secret_ability == activator):
			return true
		else:
			return false
	
	area.body_entered.connect(func(body : Node):
		if !body.is_class("Playe"):
			return
		
		elif check.call(body):
			players.append(body)
			_player_entered(body))
	area.body_exited.connect(func(body : Node):
		if !body.is_class("Player"):
			return
		
		elif check.call(body):
			players.erase(body)
			_player_exited(body))
	
	var ground_detector = RayCast2D.new()
	add_child(ground_detector)
	
	ground_detector.position = Vector2.ZERO
	ground_detector.target_position = Vector2(0,200)
	ground_detector.set_collision_mask_value(2, true)
	ground_detector.set_collision_mask_value(1, false)
	ground_detector.collide_with_bodies = true
	ground_detector.collide_with_areas = false
	ground_detector.hit_from_inside = true
	
	_interactable_ready()
	await get_tree().create_timer(0.1).timeout
	
	if ground_detector.get_collider() == null:
		var error = str(name, " is not near enough to the ground")
		push_error(error)
		
	
	else:
		position = ground_detector.get_collision_point()
	
	ground_detector.queue_free()
	

func _interactable_ready():
	pass

func _player_entered(_body : Player):
	pass
func _player_exited(_body : Player):
	pass




#var passer
#var interacted = false
#var player
#var extra_data : Array
#
#func _ready():
	#await get_tree().create_timer(0.5).timeout
	#
	#interactable_ready()
#
#func interactable_ready():
	#pass
#
#func interact(body):
	#player = body
	#interacted = true
	#action()
#
#func action():
	#pass
#
#func entered(has_entered : bool):
	#pass
#
#func check_abilities(body_ID, ability):
	#for i in GlobalScript.player_attributes.get(body_ID).get("Abilities"):
		#if i == ability:
			#return true
