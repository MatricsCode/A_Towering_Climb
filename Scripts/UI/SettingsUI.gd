extends MarginContainer

@export var main_UI : Control

@export var settings_UI : HBoxContainer

@export var video_button : HoverButton
@export var audio_button : HoverButton
@export var remap_button : HoverButton
@export var finished_button : HoverButton

@export var video_settings : VBoxContainer
@export var audio_settings : VBoxContainer
@export var remap_settings : MarginContainer

func _ready():
	settings_UI.visible = true
	remap_settings.visible = false
	
	_make_invisible()
	video_settings.visible = true
	
	video_button.pressed.connect(func(): 
		_make_invisible()
		video_settings.visible = true)
	audio_button.pressed.connect(func():
		_make_invisible()
		audio_settings.visible = true)
	remap_button.pressed.connect(func():
		_make_invisible()
		settings_UI.visible = false
		remap_settings.visible = true)
	finished_button.pressed.connect(func():
		_make_invisible()
		main_UI._return_to_settings())

func _settings(settings_visible : bool):
	settings_UI.visible = settings_visible
	remap_settings.visible = false
	_make_invisible()
	video_settings.visible = true

func _make_invisible():
	video_settings.visible = false
	audio_settings.visible = false
	remap_settings.visible = false
