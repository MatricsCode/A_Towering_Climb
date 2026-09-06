extends Interactable

const MOVING_PLATFORM_INTERACTABLE = preload("res://Art/Moving Platform/Moving Platform1.png")
const MOVING_PLATFORM_IDLE = preload("res://Art/Moving Platform/Moving Platform2.png")

@onready var area = $Area2D
@onready var sprite = $Sprite2D

@export var speed := 1

var direction = 1
var moving = false

var players = []

func _ready():
	target.loop = false
	
	area.body_entered.connect(player_entered)
	area.body_exited.connect(player_exited)

func player_entered(player):
	if check_abilities(player.ID, "Sky_Lift_Key"):
		sprite.texture = MOVING_PLATFORM_INTERACTABLE
		players.append(players)

func player_exited(player):
	sprite.texture = MOVING_PLATFORM_IDLE

func _physics_process(delta):
	if Input.is_action_pressed("Ability") and not players.is_empty():
		sprite.texture = MOVING_PLATFORM_IDLE
		moving = true
		action()
	if moving:
		for i in players:
			move(player)

func move(player):
	if moving:
		target.progress_ratio += speed * 0.01 * direction
		if direction == 1:
			player.position = target.position
		position = target.position
		
		if target.progress_ratio == 1:
			direction = -1
			player.overide(false)
			for i in player.get_children():
				if i is CollisionShape2D:
					i.disabled = false
		
		elif target.progress_ratio == 0:
			moving = false

func action():
	for i in players:
		i.overide(true)
		for y in i.get_children():
			if i is CollisionShape2D:
				i.disabled = true
	
	direction = 1
	
	moving = true
