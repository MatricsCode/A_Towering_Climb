extends Button
class_name HoverButton

const ENTER_AUDIO = preload("uid://doktp74e7kmtf")
const CLICK_AUDIO = preload("uid://f37iedscl6r7")

signal returning_name(my_name : String)

@export var wiggle := true

var time := 1.0

var hovering := false
var return_name := false

var min_size := Vector2.ONE

var audio_names := ["Enter", "Clicked"]
var audio_players := []

func _ready():
	visible = false
	
	for i in audio_names:
		var audio_player = AudioStreamPlayer.new()
		audio_player.set_bus("SFX")
		add_child(audio_player)
		audio_players.append(audio_player)
		
		if i == "Enter":
			audio_player.stream = ENTER_AUDIO
		elif i == "Click":
			audio_player.stream = CLICK_AUDIO
	
	await _spawn()
	
	if custom_minimum_size != Vector2.ZERO:
		min_size = custom_minimum_size
	
	time = randf_range(-100.0,100.0)
	pivot_offset_ratio = Vector2(0.5,0.5)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _physics_process(_delta):
	if !hovering and wiggle:
		time += 1.0
		rotation_degrees = (cos(time/20) / (size.x)) * 750

func _mouse_entered():
	hovering = true
	time = 0
	var tweener = get_tree().create_tween()
	if rotation_degrees > 0:
		rotation_degrees = -25
	else:
		rotation_degrees = 25
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "rotation_degrees", 0, 0.1)
	tweener.tween_property(self, "scale", Vector2(1.3,1.3), 0.3)
	tweener.tween_property(self, "custom_minimum_size", Vector2(min_size.x * 1.3, min_size.y * 1.3), 0.3)
	_play_sfx("Enter")
func _mouse_exited():
	hovering = false
	time += randf_range(-100.0,100.0)
	var tweener = get_tree().create_tween()
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "scale", Vector2(1,1), 0.3)
	tweener.tween_property(self, "custom_minimum_size", min_size, 0.3)

func _spawn():
	visible = true
	self_modulate.a = 0
	scale = Vector2.ZERO
	var tweener = get_tree().create_tween()
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "scale", Vector2.ONE, 0.5)
	tweener.tween_property(self, "self_modulate", Color.WHITE, 0.5)
	await tweener.finished
	visible = true
	return
func _remove():
	var tweener = get_tree().create_tween()
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tweener.tween_property(self, "scale", Vector2.ZERO, 0.1)
	tweener.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.1)
	
	await tweener.finished
	
	queue_free()

func _pressed():
	if return_name:
		returning_name.emit(name)
	_play_sfx("Clicked")

func _play_sfx(audio : String):
	audio_players.get(audio_names.find(audio)).play()
