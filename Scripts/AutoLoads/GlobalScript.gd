extends Node

var peers : Array[int]

var players : Dictionary[int , Array]
var peers_ready : Array[int]

func _ready():
	Signals.peer_joined.connect(func(ID : int): 
		peers.append(ID))
	Signals.peer_left.connect(func(ID : int):
		peers.erase(ID))
	Signals.readied_peer.connect(_check_start)

func _check_start(_ID : int):
	if Networking.host:
		if peers_ready.size() == int(Steam.getLobbyData(Networking.current_lobby, "player_count")) + 1:
			Networking._start_game.rpc()






















var peer_ID = 0
var user_ID = 0
var countdown_timer = 0.5

var important_positions = {}
var max_abilitys = 3

#var all_player_abilitys = {
	#"Glide" = preload("res://Scripts/Player/Abilitys/glide.gd"),
	#"Sky_Lift_Key" = preload("res://Scripts/Player/Abilitys/skylift_key.gd"),
	#"Climbers_Hook" = preload("res://Scripts/Player/Abilitys/climbers_hook.gd"), 
	#"Drum_Key" = preload("res://Scripts/Player/Abilitys/drum_key.gd"),
	#"Ram" = preload("res://Scripts/Player/Abilitys/ram.gd"),
	#"Sandwich" = preload("res://Scripts/Player/Abilitys/sandwich.gd"),
	#"Can_Opener" = preload("res://Scripts/Player/Abilitys/bean_opener.gd"),
	#"Repair" = preload("res://Scripts/Player/Abilitys/repair.gd"),
	#"Punch" = preload("res://Scripts/Player/Abilitys/punch.gd"),
#}

## It is {"ID" : {"Position" : Vector2, "Costume" : 0, "Abilities" : {"Key" : Ability}}}
var player_attributes = {}

func reset_now():
	player_attributes.clear()
