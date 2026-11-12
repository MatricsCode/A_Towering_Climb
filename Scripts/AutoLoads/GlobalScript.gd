extends Node

var peers : Array[int]

var players : Dictionary[int , Array]

var debug := false
var can_debug := false

var debug_inputs_last := ""
var debug_inputs : String = ""
var debug_unlock := "DEBUG"

func _ready():
	Signals.start_anim_finished.connect(func():
		can_debug = true)
	Signals.peer_joined.connect(func(ID : int): 
		peers.append(ID))
	Signals.peer_left.connect(func(ID : int):
		peers.erase(ID))
	#Signals.readied_peer.connect(_check_start)

func _input(event):
	var text = event.as_text()
	
	if text.length() > 1 or text == debug_inputs_last:
		return
	debug_inputs_last = text
	debug_inputs = str(debug_inputs, text)
	
	if !debug_unlock.contains(debug_inputs):
		debug_inputs_last = ""
		debug_inputs = ""
		return
	elif debug_unlock == debug_inputs and can_debug:
		debug = !debug
		Signals.debug.emit(debug)





















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
