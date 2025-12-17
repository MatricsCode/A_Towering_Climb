extends StaticBody2D

@export var spill_colour : Color

var players = []

@onready var area = $Area2D
@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

func _ready():
	area.body_entered.connect(player_array)
	area.body_exited.connect(player_array)

func _physics_process(_delta):
	if players.size() > 0 and sprite.animation == "Full":
		$Label.visible = true
	elif players.size() == 0 and sprite.animation == "Full":
		$Label.visible = false
	
	if players.size() > 0 and Input.is_action_pressed("Interact") and sprite.animation == "Full":
		empty()

func empty():
	sprite.play("Emptying")
	await sprite.animation_finished
	
	sprite.play("Empty")
	
	for i in players:
		player_slip(i)
		players.erase(i)
	
	area.body_entered.disconnect(player_array)
	area.body_exited.disconnect(player_array)
	
	area.body_entered.connect(player_slip)
	area.body_exited.connect(player_slip)

func player_array(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	for i in key_search:
		
		var children = i.get_children(true)
		
		for y in children:
			if y.name == key[4]:
				if body.is_multiplayer_authority():
					if players.find(body) == -1:
						players.append(body)
					else:
						players.erase(body)

func player_slip(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	for i in key_search:
		
		var children = i.get_children(true)
		
		for y in children:
			if y.name == key[4] and y.in_action == false:
				y.overide()
				print(y.name)
			elif y.name == key[4] and y.in_action == true:
				y.reset()
				print(y.name)
