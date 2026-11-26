extends Effect

var player_stats := {}
var spilled = false

func _effect_ready():
	nodes.get("sprite").animation_finished.connect(func():
		if nodes.get("sprite").animation == "Emptying":
			nodes.get("sprite").play("Empty")
			spilled = true
			for i in interactable.players:
				_stick_player(i))

func _player_entered(player : Player):
	if spilled: _stick_player(player)
	else: nodes.get("sprite").play("Emptying")
func _player_exited(player : Player):
	if spilled: _unstick_player(player)

func _stick_player(player : Player):
	var stop_vars = func():
		player.current_state = player.States.GROUND
		player.main_vars.other_vars.ability_overide = true
		player.main_vars.other_vars.can_switch = false
		player_stats[player] = [player.main_vars.ground_vars.speed]
		player.main_vars.ground_vars.speed = 50
		player.velocity = Vector2.ZERO
	
	player.position.y = interactable.position.y
	
	await get_tree().create_timer(0.1).timeout
	if interactable.players.find(player) != -1:
		stop_vars.call()
func _unstick_player(player : Player):
	if player_stats.keys().find(player) == -1:
		return
	
	player.main_vars.ground_vars.speed = player_stats.get(player).get(0)
	player.main_vars.other_vars.can_switch = true
	player.main_vars.other_vars.ability_overide = false
