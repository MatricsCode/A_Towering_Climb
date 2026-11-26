extends Interactable

var speed = {}
var jump_power = {}

var spilled := false

var player_stats := {}

func _interactable_ready():
	sprite.play("Full")

func _player_entered(body : Player):
	var player_source : PlayerSource
	player_source = body.player_source
	
	### This line just checks if any of the ability scripts of the player matches the activator
	#if (player_source.main_ability == activator or
	 #player_source.passive_ability == activator or player_source.secret_ability == activator):
		#if !spilled:
			#sprite.play("Emptying")
	#else:
		#pass
	#if spilled:
		#_stick_player(body)
func _player_exited(body : Player):
	pass
