extends StaticBody2D

enum States {FULL, EMPTYING, EMPTY}

@export var spill_colour : Color

var players = []

var current_state = States.FULL

func _ready():
	$Area2D.body_entered.connect(player_array)
	$Area2D.body_exited.connect(player_array)

func _physics_process(delta):
	if players.size() > 0 and Input.is_action_pressed("Interact"):
		current_state = States.EMPTYING
		players.clear()
		$Area2D.body_entered.disconnect(player_array)
		$Area2D.body_exited.disconnect(player_array)
		$Area2D.body_entered.connectp(player_slip)
		$Area2D.body_exited.connectp(player_slip)


func player_array(body):
	if players.find(body) == null:
		for i in body.get_children():
			if i.name == GlobalScript.all_player_abilitys[5]:
				players.append(body)
			else:
				pass
	
	else:
		players.erase(body)

func player_slip(body):
	print("sliped")
