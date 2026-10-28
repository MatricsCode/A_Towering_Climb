extends Area2D

@export var ability : String

func _player_entered(player):
	if GlobalScript.all_player_abilityes.get(player.ID).get("Abilitiy").has(ability):
		get_parent().player_entered.call(player.ID)

func _player_exited(player):
	if GlobalScript.all_player_abilityes.get(player.ID).get("Abilitiy").has(ability):
		get_parent().player_exited.call(player.ID)
