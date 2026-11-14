extends Area2D

var players = []

const MAIN_ABILITIES = {"Ram" : preload("uid://b0imh5jcjfvpr"), 
	"DummyAbility1" : preload("uid://bpmhsc3tdcpqq"), "DummyAbility2" : preload("uid://dvnr5lwr2t2n8")}
const PASS_ABILITIES = {"Glide" : preload("uid://d0y0w2hbe3jwq"), "DrumKey" : preload("uid://cx4jckeql12mb"), 
	"DummyAbility1" : preload("uid://bpmhsc3tdcpqq"), "DummyAbility2" : preload("uid://dvnr5lwr2t2n8")}
const SPRITES = {"Baker" : preload("uid://bl7fd60qs8x7s"), "Climber" : preload("uid://c2turr7b108g7"), 
	"Climber 2" : preload("uid://cfoxbudysmmgk")}
const SECRET_ABILITIES = []

@export_enum("Main", "Passive", "Sprite") var ability : int = 0

@export_group("UI")
@export var UI : Control
@export var abilities : HBoxContainer
@export var interactables_label : RichTextLabel
@export var ability_label : Label

var editing_players = []
var local_players_present = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if ability == 1: interactables_label.text = "[wave]Main Abilities:"
	elif ability == 0: interactables_label.text = "[wave]Passive Abilities:"
	else: interactables_label.text = "[wave]Character:"
	
	interactables_label.visible = true
	abilities.visible = false
	
	body_entered.connect(func(body : Player): 
		interactables_label.visible = false
		body.main_vars.other_vars.ability_overide = true
		local_players_present[body.player_source.player_number] = body)
	body_exited.connect(func(body):
		body.main_vars.other_vars.ability_overide = false
		for i in local_players_present.keys():
			if local_players_present[i] == body:
				local_players_present.erase(i)
		
		if local_players_present.size() == 0:
			interactables_label.visible = true
			abilities.visible = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		player._status_effect_update(false, "")
	else:
		abilities.visible = true
		player.current_state = player.States.PAUSED
		editing_players.append(player)
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
		var current_sprite = SPRITES.keys().get(counter.call(index, SPRITES.size()-1))
		player.player_source.sprite_frame = SPRITES[current_sprite]
		player._status_effect_update(false, current_sprite)
	
	player.update_source.emit()

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
