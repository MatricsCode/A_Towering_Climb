extends Control

@export var main_UI : MarginContainer
@export var lobby_UI : MarginContainer
@export var settings_UI : MarginContainer

@export_group("Main UI")
@export var multiplayer_button : HoverButton
@export var localplayer_button : HoverButton
@export var settings_button : HoverButton
@export var quit_button : HoverButton

func _ready():
	main_UI.visible = true
	lobby_UI.visible = false
	settings_UI.visible = false
	
	multiplayer_button.pressed.connect(func(): 
		lobby_UI.visible = true
		main_UI.visible = false)
	
	localplayer_button.pressed.connect(func(): pass)
	settings_button.pressed.connect(func():
		main_UI.visible = false
		lobby_UI.visible = false
		settings_UI.visible = true)
	quit_button.pressed.connect(get_tree().quit)

func _return_to_settings():
	main_UI.visible = true
	lobby_UI.visible = false
	settings_UI.visible = false
