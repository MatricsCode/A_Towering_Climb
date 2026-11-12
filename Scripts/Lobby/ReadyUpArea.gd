extends Area2D

@export var TEST : Texture2D

var text : Label
var players_present : Array[Player]
var local_players_present = {int = Player}

func _ready():
	players_present = []
	
	body_entered.connect(func(body : Player):
		body.main_vars.other_vars.ability_overide = true
		players_present.append(body)
		local_players_present[body.player_source.player_number] = body
		print(local_players_present))
	
	body_exited.connect(func(body):
		body.main_vars.other_vars.ability_overide = false
		players_present.erase(body)
		local_players_present.erase(body.player_source.player_number))

func _physics_process(delta):
	if Input.is_action_just_pressed("P1_Interact") and local_players_present.keys().has(1):
		_make_ready(local_players_present.get(1))
	elif Input.is_action_just_pressed("P2_Interact") and local_players_present.keys().has(2):
		_make_ready(local_players_present.get(2))
	elif Input.is_action_just_pressed("P3_Interact") and local_players_present.keys().has(3):
		_make_ready(local_players_present.get(3))

func _make_ready(player : Player):
	player._status_effect_pic(TEST)
	Networking._send_data(player, true)
