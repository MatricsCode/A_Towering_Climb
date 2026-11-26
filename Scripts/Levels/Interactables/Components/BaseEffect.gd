extends Node
class_name Effect

@export var interactable : Interactable = null
@export var nodes : Dictionary[String, Node]

func _ready():
	set_process_mode(PROCESS_MODE_DISABLED)
	interactable.player_entered.connect(_player_entered)
	interactable.player_exited.connect(_player_exited)
	
	_effect_ready()

func _effect_ready():
	pass

func _player_entered(player : Player):
	pass
func _player_exited(player : Player):
	pass

func _is_active():
	pass
