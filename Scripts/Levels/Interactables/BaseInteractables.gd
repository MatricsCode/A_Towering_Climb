extends Node2D
class_name Interactable

signal player_entered(body : Player)
signal player_exited(body : Player)

@export_group("Main")
## All of the different Scripts which cause this interactable be interacted with go here.
## Example: Beans can either be picked up and eaten (caused by Ability1) OR spilled (caused by Ability1).
@export var activators : Array[Script]
## All of the different methods to interact with this interactable go here.
## Example: Beans can either be picked up and eaten (Effect1) OR spilled (Effect2).
## Preferably, you put the activator and the effect on the same index
@export var effects  : Array[Node]
## If the activator script is on a different index to it's matching effect, 
## add the index of the activator script as the key and the index of the effect script as the value.
## It will be automatically rerouted in the _check_abilities function
@export var links : Dictionary[int, int]

@export_group("Nodes")
@export var area : Area2D
@export var sprite : AnimatedSprite2D

@export_group("Optional")
@export var target : Node
@export var auto_setup_area := true

var players := []

func _ready():
	if auto_setup_area:
		area.body_entered.connect(func(body : Node):
			if !body.is_class("CharacterBody2D"):
				return
			
			elif _check_abilities(body) != -1:
				players.append(body)
				_player_entered(body)
				
				player_entered.emit(body))
		area.body_exited.connect(func(body : Node):
			if !body.is_class("CharacterBody2D"):
				return
			
			elif _check_abilities(body)  != -1:
				players.erase(body)
				_player_exited(body)
				
				
				player_exited.emit(body))
	
	for i in effects:
		i.set_process_mode(PROCESS_MODE_DISABLED)
	
	_interactable_ready()

func _interactable_ready():
	pass

## Called automatically (if auto_setup_area is true) when a player enters the interactable
func _player_entered(_body : Player):
	pass
## Called automatically (if auto_setup_area is true) when a player exits the interactable
func _player_exited(_body : Player):
	pass

## This checks the activators array for it the player has a coresponding ability.
## If the player does, it then goes through the links dictionary to see if there is a corresponding link
## It then returns the index of the corresponding effect in the effects dictionary
## If the player does NOT have a corresponding ability, this function returns -1
func _check_abilities(player : Player) -> int:
	var player_stats : PlayerSource
	player_stats = player.player_source
	
	var index = -1
	
	## This line just checks if any of the ability scripts of the player matches the activator
	for i in activators:
		if (player_stats.main_ability == i or
		 player_stats.passive_ability == i or player_stats.secret_ability == i):
			index = activators.find(i)
	
	if index == -1:
		return -1
	
	var code_to_execute : int = index if !links.has(index) else links.get(index)
	
	return code_to_execute
func _stick_to_ground(vertical_offset : float = 0):
	var ground_detector = RayCast2D.new()
	add_child(ground_detector)
	
	ground_detector.position = Vector2.ZERO
	ground_detector.target_position = Vector2(0,200)
	ground_detector.set_collision_mask_value(2, true)
	ground_detector.set_collision_mask_value(1, false)
	ground_detector.collide_with_bodies = true
	ground_detector.collide_with_areas = false
	ground_detector.hit_from_inside = true
	
	await get_tree().create_timer(0.1).timeout
	
	if ground_detector.get_collider() == null:
		var error = str(name, " is not near enough to the ground")
		push_error(error)
		
	
	else:
		position = ground_detector.get_collision_point()
		position.y -= vertical_offset
	
	ground_detector.queue_free()
