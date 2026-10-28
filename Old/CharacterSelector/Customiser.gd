extends MarginContainer

const OUTFITS =[preload("uid://bl7fd60qs8x7s"), preload("uid://c2turr7b108g7")]
const ANIMATIONS = [preload("uid://bjixmhtfjc485"), preload("uid://jkldqbjs1i6u")]
var current_outfit := 0
var anim_outfit := 0

@export var last_outfit_button : HoverButton
@export var next_outfit_button : HoverButton

@export var centre_point : Control
@export var sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.sprite_frames = ANIMATIONS[0]
	sprite.play("idle")
	
	last_outfit_button.pressed.connect(func():
		current_outfit = _check_outfits(-1))
	next_outfit_button.pressed.connect(func():
		current_outfit = _check_outfits(1))
	
	sprite.animation_finished.connect(func():
		if sprite.animation == "exit":
			sprite.sprite_frames = ANIMATIONS[current_outfit]
			sprite.play("enter")
			anim_outfit = current_outfit
		elif sprite.animation == "enter" and anim_outfit == current_outfit:
			sprite.play("idle")
		elif sprite.animation == "enter" and anim_outfit != current_outfit:
			sprite.play("exit")
			anim_outfit = current_outfit)
	
	sprite.sprite_frames_changed.connect(func():
		pass)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sprite.position = centre_point.position

func _check_outfits(direction := -1):
	var value := 0
	
	if current_outfit + direction < 0:
		value = ANIMATIONS.size()-1
	elif current_outfit + direction > ANIMATIONS.size()-1:
		value = 0
	else:
		value = current_outfit + direction
	
	if sprite.animation == "idle":
		sprite.play("exit")
	
	return value
