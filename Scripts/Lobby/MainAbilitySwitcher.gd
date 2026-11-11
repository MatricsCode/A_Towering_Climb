extends Area2D

var players = []

const MAIN_ABILITIES = {"Ram" : preload("uid://b0imh5jcjfvpr"), 
	"DummyAbility1" : preload("uid://bpmhsc3tdcpqq"), "DummyAbility2" : preload("uid://dvnr5lwr2t2n8")}
const PASS_ABILITIES = {"Glide" : preload("uid://d0y0w2hbe3jwq"), "DrumKey" : preload("uid://cx4jckeql12mb"), 
	"DummyAbility1" : preload("uid://bpmhsc3tdcpqq"), "DummyAbility2" : preload("uid://dvnr5lwr2t2n8")}

@export_enum("Main", "Passive") var ability := 0

@export_group("UI")
@export var UI : Control
@export var abilities : HBoxContainer
@export var interactables_label : RichTextLabel
@export var ability_label : Label

var switching_abilities := false

var editing_players = []

var players_present = []
var local_players_present = []

# Called when the node enters the scene tree for the first time.
func _ready():
	players_present = []
	
	body_entered.connect(func(body : Player):
		body.main_vars.other_vars.ability_overide = true
		players_present.append(body)
		local_players_present[body.player_source.player_number] = body)
	
	body_exited.connect(func(body):
		body.main_vars.other_vars.ability_overide = false
		players_present.erase(body))
	
	#last_ability_button.pressed.connect(func():
		#if ability == 0:
			#var player = players[0]
			#var text1 = player.player_source.main_ability
			#text1 = text1.split("/")
			#text1 = text1[text1.size()-1]
			#text1 = text1.split(".")
			#text1 = text1[0]
			#print(text1))
	#next_ability_button.pressed.connect(func():
		#if ability == 0:
			#pass)
#
#func _body_entered(body : Player):
	#if players.is_empty():
		#interactables_label.text = "E"
	#players.append(body)
#func _body_exited(body : Player):
	#players.erase(body)
	#if players.is_empty():
		#_norm_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("P1_Interact") and local_players_present.keys().has(1):
		_new_editing_player(local_players_present.get(1))
	elif Input.is_action_just_pressed("P2_Interact") and local_players_present.keys().has(2):
		_new_editing_player(local_players_present.get(2))
	elif Input.is_action_just_pressed("P3_Interact") and local_players_present.keys().has(3):
		_new_editing_player(local_players_present.get(3))
	
	#if Input.is_action_just_pressed(player.inputs.interact) and !switching_abilities:
		#for player in players:
			#if player.player_source.steam_ID == Steam.getSteamID():
				#player.current_state = player.States.EMPTY
				#player.sprite.play("idle")
				#player.velocity = Vector2.ZERO
				#switching_abilities = true
	#elif Input.is_action_just_pressed(player.inputs.interact) and switching_abilities:
		#for player in players:
			#if player.player_source.steam_ID == Steam.getSteamID():
				#player.current_state = player.States.GROUND
				#switching_abilities = false
	
	if switching_abilities:
		if Input.is_action_just_pressed("Left"):
			_change_ability(-1)
		elif Input.is_action_just_pressed("Right"):
			_change_ability(1)

func _change_ability(direction : int):
	pass

func _norm_text():
	if ability == 0:
		interactables_label.text = "Main Abilities:"
	elif ability == 1:
		interactables_label.text = "Passive Abilities:"
	else:
		interactables_label.text = "Ready?"
		abilities.visible = false

func _return_number(starting_number : int, direction : int,  max_number : int):
	var new_number = starting_number + direction
	max_number = max_number-1
	if new_number < max_number and new_number > 0:
		return new_number
	elif new_number >= max_number:
		new_number = 0
	elif new_number < 0:
		new_number = max_number

func _new_editing_player(player):
	pass

func _inputs(_event):
	var local_players = {}
	for i in players:
		if i.player_source.steam_ID == Steam.getSteamID():
			local_players[i.player_source.player_number+1] = i
	
	if Input.is_action_just_pressed("P1_Ability") and local_players.keys().has(1):
		editing_players.append(local_players.get(1))
	elif Input.is_action_just_pressed("P2_Ability") and local_players.keys().has(2):
		editing_players.append(local_players.get(2))
	elif Input.is_action_just_pressed("P3_Ability") and local_players.keys().has(3):
		editing_players.append(local_players.get(3))
	elif Input.is_action_just_pressed("P4_Ability") and local_players.keys().has(4):
		editing_players.append(local_players.get(4))
