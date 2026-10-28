extends MarginContainer

const OUTFITS = [preload("uid://bjixmhtfjc485"), preload("uid://jkldqbjs1i6u")]
var current_outfit := 0

@export var last_outfit_button : HoverButton
@export var next_outfit_button : HoverButton

@export var centre_point : Control
@export var sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	last_outfit_button.pressed.connect(func():
		current_outfit = _check_outfits(-1))
	next_outfit_button.pressed.connect(func():
		current_outfit = _check_outfits(1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _check_outfits(direction := -1):
	if current_outfit + direction < 0:
		return OUTFITS.size()
	elif current_outfit + direction > OUTFITS.size():
		return 0
	else:
		return current_outfit + direction
