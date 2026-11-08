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
	_update()
	player.update_source.connect(_update)
	
	Signals.lobby_start_game.connect(func():
		for i in get_children():
			i.queue_free()
		player.current_state = player.States.OVERIDDEN)
	Signals.start_anim_finished.connect(_update)

func _add_ability(script : Script, ability_name : String):
	var ability = Ability.new()
	
	ability.name = str(ability_name, "Ability")
	ability.set_script(script)
	ability.player = player
	ability.sprite = sprite
	ability.detectors = detectors
	
	add_child(ability)

func _update():
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
