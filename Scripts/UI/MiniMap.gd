extends Control

@export var main_sliders : Control

var has_started := false
var players : Control
var objects : Control

func _ready():
	visible = false
	Signals.lobby_start_game.connect(_start)

func _physics_process(_delta):
	if has_started:
		_update()

func _start():
	players = Control.new()
	main_sliders.add_child(players)
	
	for i in GlobalScript.player_positions.values():
		var slider = _base_slider()
		slider.theme = i.player_source.slider_theme
		players.add_child(slider)
	
	objects = Control.new()
	main_sliders.add_child(objects)
	for i in GlobalScript.important_positions.values():
		var slider = _base_slider()
		players.add_child(slider)

	
	visible = true
	has_started = true

func _update():
	pass

func _base_slider():
	var slider = HSlider.new()
	slider.min_value = GlobalScript.level_height
	slider.max_value = -20
	
	return slider
