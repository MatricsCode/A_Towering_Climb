extends MarginContainer

var current_outfit = 0
var outfits = [preload("res://Components/SpriteFrames/Players/Climber1.tres"), 
	preload("res://Components/SpriteFrames/Players/Climber2.tres"), preload("res://Components/SpriteFrames/Players/Baker.tres")]

@export var last_outfit_button : HoverButton
@export var next_outfit_button : HoverButton

@export var anim_sprite_2 : AnimatedSprite2D
@export var anim_sprite : AnimatedSprite2D

var hider : AnimatedSprite2D = anim_sprite_2

# Called when the node enters the scene tree for the first time.
#func _ready():
	#last_outfit_button.pressed.connect(func():
		#current_outfit = _check_outfits(-1))
	#next_outfit_button.pressed.connect(func():
		#current_outfit = _check_outfits(1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _check_outfits(direction := -1):
	if current_outfit + direction < 0:
		return outfits.size()
	elif current_outfit + direction > outfits.size():
		return 0
	else:
		return current_outfit + direction
