extends Node

@export var main_player : Player

var main : Script
var sec_1 : Script
var sec_2 : Script

func _ready():
	main = main_player.player_source.main_ability
	sec_1 = main_player.player_source.passive_ability_1
	sec_2 = main_player.player_source.passive_ability_2
