extends Node

@export var player : Player
@export var sprite : AnimatedSprite2D
@export var detectors : Node2D


var main : Script
var passive : Script
#var sec_1 : Script
#var sec_2 : Script
var secret : Script

func _ready():
	main = player.player_source.main_ability
	passive = player.player_source.passive_ability
	#sec_1 = player.player_source.passive_ability_1
	#sec_2 = player.player_source.passive_ability_2
	secret = player.player_source.secret_ability
	
	_add_ability(main, "Main")
	_add_ability(passive, "Passive")
	#_add_ability(sec_1, "Secondary 1")
	#_add_ability(sec_2, "Secondary 2")
	_add_ability(secret, "Secret")

func _add_ability(script : Script, ability_name : String):
	var ability = Ability.new()
	
	ability.name = str(ability_name, "Ability")
	ability.set_script(script)
	ability.player = player
	ability.sprite = sprite
	ability.detectors = detectors
	
	add_child(ability)
