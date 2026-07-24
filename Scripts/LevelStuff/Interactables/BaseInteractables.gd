extends StaticBody2D

class_name Interactable

## 0 is Glide, 1 is Sky Lift Key, 2 is Climbers Hook, 3 is Drum Key, 4 is Ram
@export var activator : String
@export var target : Node

var passer
var interacted = false
var player
var extra_data : Array

func _ready():
	await get_tree().create_timer(0.5).timeout
	
	interactable_ready()

func interactable_ready():
	pass

func interact(body):
	player = body
	interacted = true
	action()

func action():
	pass

func entered(has_entered : bool):
	pass

func check_abilities(body_ID, ability):
	for i in GlobalScript.player_attributes.get(body_ID).get("Abilities"):
		if i == ability:
			return true
