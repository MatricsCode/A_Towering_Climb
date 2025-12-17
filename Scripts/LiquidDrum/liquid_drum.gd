extends StaticBody2D

enum States {FULL, EMPTYING, EMPTY}

@export var spill_colour : Color

var players = []

var current_state = States.FULL

func _ready():
	$Area2D.body_entered.connect(player_array)
	$Area2D.body_exited.connect(player_array)

func _physics_process(delta):
	if players.size() > 0:
		$Label.visible = true
	else:
		$Label.visible = false
	
	if players.size() > 0 and Input.is_action_pressed("Interact"):
		current_state = States.EMPTYING
		players.clear()
		$Area2D.body_entered.disconnect(player_array)
		$Area2D.body_exited.disconnect(player_array)
		$Area2D.body_entered.connectp(player_slip)
		$Area2D.body_exited.connectp(player_slip)


func player_array(body):
	var keys = GlobalScript.all_player_abilitys.keys()
	
	print(body.name)
	
	if players.find(body) == -1:
		print(body.get_child_count(true))
		for i in body.get_child_count(true):
			if body.get_child(i, true).name == keys[4]:
				players.append(body)
				print(players)
				return
			else:
				pass
	
	else:
		players.erase(body)
	
	print(players)

func player_slip(body):
	print("sliped")
