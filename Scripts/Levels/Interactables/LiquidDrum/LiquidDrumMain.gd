extends Interactable

var current_effect := -1

func _interactable_ready():
	sprite.play("Full")
	_stick_to_ground()

func _player_entered(body : Player):
	var player_source : PlayerSource
	player_source = body.player_source
	
	var number = _check_abilities(body)
	
	if number > 100:
		return
	if number != -1 and current_effect == -1:
		effects.get(number).set_process_mode(PROCESS_MODE_INHERIT)
		current_effect = number
func _player_exited(body : Player):
	pass
