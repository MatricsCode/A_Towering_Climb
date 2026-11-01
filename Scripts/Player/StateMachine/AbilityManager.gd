extends Node

@export var main_player : Player

var main : Script
var sec_1 : Script
var sec_2 : Script
var secret : Script

func _ready():
	main = main_player.player_source.main_ability
	sec_1 = main_player.player_source.passive_ability_1
	sec_2 = main_player.player_source.passive_ability_2
	secret = main_player.player_source.secret_ability
	
	_add_ability(main, "Main")
	_add_ability(sec_1, "Secondary 1")
	_add_ability(sec_2, "Secondary 2")
	_add_ability(secret, "Secret Ability")

func _add_ability(script : Script, ability_name : String):
	var ability = Ability.new()
	add_child(ability)
	ability.name = ability_name
	ability.set_script(script)
