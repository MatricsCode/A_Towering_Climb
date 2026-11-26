extends Control

@export var main_sliders : Control

var has_started := false
var players : Control
var objects : Control

func _ready():
	visible = false
	
	players = Control.new()
	players.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_sliders.add_child(players)
	
	objects = Control.new()
	objects.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_sliders.add_child(objects)
	
	Signals.lobby_start_game.connect(_start)
	Signals.lobby_finished_game.connect(_finish)

func _physics_process(_delta):
	if has_started:
		_update()

func _start():
	while GlobalScript.level_height == 0:
		await get_tree().create_timer(0.1).timeout
	
	for i in GlobalScript.player_positions.keys():
		var slider = _base_slider(players)
		slider.theme = i.player_source.slider_theme
	for i in GlobalScript.important_positions.keys():
		_base_slider(objects)
	
	visible = true
	
	await get_tree().create_timer(0.1).timeout
	has_started = true
func _finish(_body):
	visible = false
	
	for i in players.get_children():
		i.queue_free()
	for i in objects.get_children():
		i.queue_free()

func _update():
	for player in GlobalScript.player_positions.keys():
		var index = GlobalScript.player_positions.keys().find(player)
		var slider = players.get_child(index)
		slider.value = player.position.y * -1

func _base_slider(parent : Node):
	var slider = VSlider.new()
	slider.min_value = 0
	slider.max_value = GlobalScript.level_height
	slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	parent.add_child(slider)
	
	
	return slider
