extends StaticBody2D
class_name Interactable

@export var activator : Script
@export var area : Area2D
@export var sprite : AnimatedSprite2D
@export var target : Node

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
		if check.call(body):
			pass)
	area.body_exited.connect(func(body : Node):
		if check.call(body):
			pass)







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
