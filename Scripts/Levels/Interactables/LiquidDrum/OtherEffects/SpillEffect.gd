extends Node

@export var liquid_drum : Interactable
@export var sprite : AnimatedSprite2D

var player_stats := {}

func _ready():
	liquid_drum.player_entered.connect(_stick_player)
	liquid_drum.player_exited.connect(_unstick_player)
	sprite.animation_changed.connect(func():
		if sprite.animation == "Emptying":
			sprite.play("Empty")
			spilled = true
			for i in players:
				_stick_player(i))

func _stick_player(player : Player):
	player.position.y = liquid_drum.position.y
	player.current_state = player.States.GROUND
	player.main_vars.other_vars.can_switch = false
	player_stats[player] = player.main_vars.ground_vars.speed
	player.main_vars.ground_vars.speed = 50
func _unstick_player(player : Player):
	if player_stats.keys().find(player) == -1:
		return
	
	player.main_vars.ground_vars.speed = player_stats[player]
	player.main_vars.other_vars.can_switch = true

func _pass():
	pass
