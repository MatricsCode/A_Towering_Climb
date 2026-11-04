extends Interactable

var speed = {}
var jump_power = {}

var spilled := false

var player_stats := {}

func _interactable_ready():
	sprite.play("Full")
	area.body_entered.connect(_player_entered)
	area.body_exited.connect(_player_exited)
	sprite.animation_changed.connect(func():
		if sprite.animation == "Emptying":
			sprite.play("Empty")
			spilled = true
			for i in players:
				_stick_player(i))

func _player_entered(body : Player):
	var player_source : PlayerSource
	player_source = body.player_source
	
	## This line just checks if any of the ability scripts of the player matches the activator
	if (player_source.main_ability == activator or
	 player_source.passive_ability == activator or player_source.secret_ability == activator):
		if !spilled:
			sprite.play("Emptying")
	else:
		pass
	_stick_player(body)
	
func _player_exited(body : Player):
	_unstick_player(body)

func _stick_player(player : Player):
	player.position.y = position.y
	player.current_state = player.States.GROUND
	player.main_vars.other_vars.can_switch = false
	player_stats[player] = player.main_vars.ground_vars.speed
	player.main_vars.ground_vars.speed = 50
func _unstick_player(player : Player):
	player.main_vars.ground_vars.speed = player_stats[player]
	player.main_vars.other_vars.can_switch = true

#func player_entered(player):
	#if sprite.animation == "Full":
		#sprite.play("Interactable")
	#
	#elif sprite.animation == "Empty":
		#player.current_state = 4
		#
		#await get_tree().create_timer(0.2).timeout
		#
		#player.velocity.x = 100 * player._get_sprite_rotation()
		#player.sprite.play("walk")
#
#func player_exited(player):
	#if sprite.animation == "Interactable":
		#sprite.play("Full")
	#
	#player.current_state = 0

#func action():
	#sprite.play("Emptying")
	#
	#await sprite.animation_finished
	#
	#sprite.play("Empty")
#
#func slip_add(body):
	#if sprite.animation == "Empty":
		#speed[body] = body.main_vars_reset[0]
		#jump_power[body] = body.main_vars_reset[1]
		#
		#body.main_vars.air_vars["jump_power"] = 10
		#body.main_vars_reset[1] = 10
		#body.main_vars.ground_vars["speed"] = 200
		#body.main_vars_reset[0] = 200
#
#func slip_remove(body):
	#if sprite.animation == "Empty":
		#body.main_vars.ground_vars["speed"] = speed[body]
		#body.main_vars_reset[0] = speed[body]
		#speed.erase(body)
		#
		#body.main_vars.air_vars["jump_power"] = jump_power[body]
		#body.main_vars_reset[1] = jump_power[body]
		#jump_power.erase(body)
#
#
#func entered(has_entered : bool):
	#if has_entered and sprite.animation == "Full":
		#sprite.play("Interactable")
	#elif has_entered == false and not interacted:
		#sprite.play("Full")

#func _ready():
	#GlobalScript.important_positions[position] = 5
#
#func _physics_process(_delta):
	#if players.is_empty() == false and sprite.animation == "Full":
		#sprite.play("Emptying")
		#
		#await sprite.animation_finished
		#
		#sprite.play("Empty")
