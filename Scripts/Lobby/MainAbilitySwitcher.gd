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

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
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

func _body_entered(body : Player):
	players.append(body)
	if abilities.visible == false:
		interactables_label.visible = true
func _body_exited(body : Player):
	players.erase(body)
	if players.is_empty():
		interactables_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact") and !switching_abilities:
		for player in players:
			if player.player_source.steam_ID == Steam.getSteamID():
				player.current_state = player.States.EMPTY
				player.sprite.play("idle")
				player.velocity = Vector2.ZERO
				switching_abilities = true
	elif Input.is_action_just_pressed("Interact") and switching_abilities:
		for player in players:
			if player.player_source.steam_ID == Steam.getSteamID():
				player.current_state = player.States.GROUND
				switching_abilities = false
	
	if switching_abilities:
		if Input.is_action_just_pressed("Left"):
			_change_ability(-1)
		elif Input.is_action_just_pressed("Right"):
			_change_ability(1)

func _change_ability(direction : int):
	pass

func _return_number(starting_number : int, direction : int,  max_number : int):
	var new_number = starting_number + direction
	max_number = max_number-1
	if new_number < max_number and new_number > 0:
		return new_number
	elif new_number >= max_number:
		new_number = 0
	elif new_number < 0:
		new_number = max_number
