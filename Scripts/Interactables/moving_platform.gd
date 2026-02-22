extends Interactable

const MOVING_PLATFORM_INTERACTABLE = preload("res://Art/Moving Platform/Moving Platform1.png")
const MOVING_PLATFORM_IDLE = preload("res://Art/Moving Platform/Moving Platform2.png")

@export var speed := 1

var direction = 1
var moving = false

func _ready():
	target.loop = false

func _physics_process(delta):
	if moving:
		target.progress_ratio += speed * 0.01 * direction
		player.position = target.position
		position = target.position
		
		if target.progress_ratio != 0 and target.progress_ratio != 1:
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
	
	if target.progress_ratio == 0:
		direction = 1
	elif target.progress_ratio == 1:
		direction = -1
	
	moving = true
