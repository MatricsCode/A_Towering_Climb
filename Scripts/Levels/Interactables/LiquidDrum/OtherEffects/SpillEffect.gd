extends Node

@export var liquid_drum : Interactable
@export var sprite : AnimatedSprite2D

var player_stats := {}
var spilled = false

func _ready():
	liquid_drum.player_entered.connect(func(body : Player):
		if spilled: _stick_player(body)
		else: sprite.play("Emptying"))
	liquid_drum.player_exited.connect(func(body : Player):
		if spilled: _unstick_player(body)
		else: pass)
	sprite.animation_finished.connect(func():
		if sprite.animation == "Emptying":
			sprite.play("Empty")
			spilled = true
			for i in liquid_drum.players:
				_stick_player(i))

func _stick_player(player : Player):
	var stop_vars = func():
		player.current_state = player.States.GROUND
		player.main_vars.other_vars.ability_overide = true
		player.main_vars.other_vars.can_switch = false
		player_stats[player] = [player.main_vars.ground_vars.speed]
		player.main_vars.ground_vars.speed = 50
		player.velocity = Vector2.ZERO
	
	player.position.y = liquid_drum.position.y
	
	await get_tree().create_timer(0.1).timeout
	if liquid_drum.players.find(player) != -1:
		stop_vars.call()
func _unstick_player(player : Player):
	if player_stats.keys().find(player) == -1:
		return
	
	player.main_vars.ground_vars.speed = player_stats.get(player).get(0)
	player.main_vars.other_vars.can_switch = true
	player.main_vars.other_vars.ability_overide = false

func _pass():
	pass
