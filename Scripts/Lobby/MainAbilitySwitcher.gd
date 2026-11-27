extends Area2D

var players = []
var player_inputs : Dictionary[Player, String] = {}
var player_left_right : Dictionary[Player, Array] = {}

const MAIN_ABILITIES = {"Ram" : preload("uid://b0imh5jcjfvpr"), "ClimbersHook" : preload("uid://d1orsl3fcwm7b"),
	"Punch": preload("uid://dguxchtm12cvo"), "Bean Projectile" : preload("uid://43xq3swqbxdi")}
const PASS_ABILITIES = {"Glide" : preload("uid://d0y0w2hbe3jwq"), "DrumKey" : preload("uid://cx4jckeql12mb"), 
	"Eating Beans" : preload("uid://clix5xqay4du2"), "Spilling Beans" : preload("uid://1pvjkp0rf4rn")}
const SPRITES = {"Baker" : preload("uid://bl7fd60qs8x7s"), "Climber" : preload("uid://c2turr7b108g7"), 
	"Climber 2" : preload("uid://cfoxbudysmmgk")}
const SPRITE_THEME = [preload("uid://d0fl0yg8b5iq2"), preload("uid://c5qlnyqt7qlc3"), 
	preload("uid://s0cgft0kbrqu")]
const SECRET_ABILITIES = []

@export_enum("Passive", "Main", "Sprite") var ability : int = 0

@export_group("UI")
@export var UI : Control
@export var interactables_label : RichTextLabel
@export var ability_label : Label
@export var left_input_text : RichTextLabel
@export var right_input_text : RichTextLabel

var editing_players = []
var local_players_present = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_match_text()
	
	body_entered.connect(func(body : Player):
		body.main_vars.other_vars.ability_overide = true
		body.reset_abilities.emit()
		local_players_present[body.player_source.player_number] = body
		_show_interact_input(body))
	body_exited.connect(func(body):
		body.main_vars.other_vars.ability_overide = false
		for i in local_players_present.keys():
			if local_players_present[i] == body:
				local_players_present.erase(i)
				
		
		_update_text())
	
	interactables_label.visible = true
	left_input_text.visible = true
	right_input_text.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("P1_Interact") and local_players_present.keys().has(1):
		_editing_player(local_players_present.get(1))
	elif Input.is_action_just_pressed("P2_Interact") and local_players_present.keys().has(2):
		_editing_player(local_players_present.get(2))
	elif Input.is_action_just_pressed("P3_Interact") and local_players_present.keys().has(3):
		_editing_player(local_players_present.get(3))
	
	for player in editing_players:
		if Input.is_action_just_pressed(player.inputs.Left):
			_change_ability(-1, player)
		elif Input.is_action_just_pressed(player.inputs.Right):
			_change_ability(1, player)

func _editing_player(player : Player):
	if editing_players.has(player):
		player.current_state = player.States.GROUND
		editing_players.erase(player)
		player_left_right.erase(player)
		_update_text()
		
		if editing_players.is_empty():
			_match_text()
		
		player._status_effect_update(false, "")
	else:
		player.current_state = player.States.PAUSED
		editing_players.append(player)
		player._status_effect_update(true, null)
		Networking._send_data(player, false)
		
		_show_switching_input(player)
		
		## These lines search for the correct ability/sprite name in and show it on
		## The players secondary text field
		if ability == 1:
			var all_abilities = MAIN_ABILITIES.values()
			var index = all_abilities.find(player.player_source.main_ability)
			player._status_effect_update(false, MAIN_ABILITIES.keys()[index])
		elif ability == 0:
			var all_abilities = PASS_ABILITIES.values()
			var index = all_abilities.find(player.player_source.passive_ability)
			player._status_effect_update(false, PASS_ABILITIES.keys()[index])
		else:
			var all_sprites = SPRITES.values()
			var index = all_sprites.find(player.player_source.sprite_frame)
			player._status_effect_update(false, SPRITES.keys()[index])
func _change_ability(direction : int, player : Player):
	var counter = func(number : int, size : int):
		if number + direction > size:
			number = 0
		elif number + direction < 0:
			number = size
		else:
			number = number + direction
		return number
	
	if ability == 1:
		var all_abilities = MAIN_ABILITIES.values()
		var index = all_abilities.find(player.player_source.main_ability)
		var current_ability = MAIN_ABILITIES.keys().get(counter.call(index, MAIN_ABILITIES.size()-1))
		player.player_source.main_ability = MAIN_ABILITIES[current_ability]
		player._status_effect_update(false, current_ability)
	elif ability == 0:
		var all_abilities = PASS_ABILITIES.values()
		var index = all_abilities.find(player.player_source.passive_ability)
		var current_ability = PASS_ABILITIES.keys().get(counter.call(index, PASS_ABILITIES.size()-1))
		player.player_source.passive_ability = PASS_ABILITIES[current_ability]
		player._status_effect_update(false, current_ability)
	else:
		var all_sprites = SPRITES.values()
		var index = all_sprites.find(player.player_source.sprite_frame)
		index = counter.call(index, SPRITES.size()-1)
		var current_sprite = SPRITES.keys().get(index)
		player.player_source.sprite_frame = SPRITES[current_sprite]
		player.player_source.slider_theme = SPRITE_THEME[index]
		player._status_effect_update(false, current_sprite)
	
	player.update_source.emit()

func _show_interact_input(body : Player):
	var action = body.inputs.Interact
	var current_input_event = InputMap.action_get_events(action)
	var input = str(current_input_event).split("(")[1]
	input = input.split(")")[0]
	
	player_inputs[body] = input
	
	_update_text()
func _show_switching_input(body : Player):
	var left_action = body.inputs.Left
	var right_action = body.inputs.Right
	
	var left_input = str(InputMap.action_get_events(left_action))
	var right_input = str(InputMap.action_get_events(right_action))
	
	left_input = left_input.split("(")[1]
	right_input = right_input.split("(")[1]
	
	left_input = left_input.split(")")[0]
	right_input = right_input.split(")")[0]
	
	
	player_inputs.erase(body)
	player_left_right[body] = [left_input, right_input]
	
	_update_text()
	#var action = body.inputs.Interact
	#var current_input_events = InputMap.action_get_events(action)
	#var input = str(current_input_event).split("(")[1]
	#input = input.split(")")[0]
	#
	#interactables_label.text = str("[wave]Press : ", input)
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

func _update_text():
	if player_inputs.size() > 0:
		var string := ""
		for i in player_inputs.values():
			string = str(string, ", ", i) if string.length() > 0 else i
		
		
		interactables_label.text = str("[wave amp=100]Press : ", string)
	else:
		interactables_label.text = ""
	
	if player_left_right.size() > 0:
		var array = []
		for i in player_left_right.values():
			array.append(i)
		
		
		
		
		var left_string : String = ""
		var right_string : String = ""
		
		for i in array:
			left_string = (str(left_string, "\n", i[0]) if left_string.length() > 0 
				else str("[wave amp=100]", i[0]))
			right_string = (str(right_string, "\n", i[1]) if right_string.length() > 0 
				else str("[wave amp=100]",i[1]))
		left_input_text.text = left_string
		right_input_text.text = right_string
	else:
		left_input_text.text = ""
		right_input_text.text = ""

func _match_text():
	if ability == 1: interactables_label.text = "[wave amp=200]Main Abilities:"
	elif ability == 0: interactables_label.text = "[wave amp=50]Passive Abilities:"
	else: interactables_label.text = "[tornado]Character:"
