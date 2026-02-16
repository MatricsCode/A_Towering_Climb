extends Interactable

const MOVING_PLATFORM_INTERACTABLE = preload("res://Art/Moving Platform/Moving Platform1.png")
const MOVING_PLATFORM_IDLE = preload("res://Art/Moving Platform/Moving Platform2.png")

@export var speed := 1

@export var path : PathFollow2D

var direction = 1
var moving = false

func _ready():
	path.loop = false

func _physics_process(delta):
	if moving:
		path.progress_ratio += speed * 0.01 * direction
		player.position = path.position
		position = path.position
		
		if path.progress_ratio != 0 and path.progress_ratio != 1:
			pass
		else:
			moving = false
			player.overide(false)
			for i in player.get_children():
				if i is CollisionShape2D:
					i.disabled = false

func entered(has_entered : bool):
	if has_entered:
		$Sprite2D.texture = MOVING_PLATFORM_INTERACTABLE
	else:
		$Sprite2D.texture = MOVING_PLATFORM_IDLE

func action():
	player.overide(true)
	
	$Sprite2D.texture = MOVING_PLATFORM_IDLE
	
	for i in player.get_children():
		if i is CollisionShape2D:
			i.disabled = true
	
	if path.progress_ratio == 0:
		direction = 1
	elif path.progress_ratio == 1:
		direction = -1
	
	moving = true
