extends Control

@onready var anim_close = $AnimationPlayerClose
@onready var anim_open = $AnimationPlayerOpen

@onready var lobby_ui = $LobbyUI
@onready var main_ui = $MainUI
@onready var caracter_selector_ui = $CaracterSelectorUI

func _ready():
	#Signals.host_created.connect()
	Signals.lobby_joined.connect(_lobby_joined)
	
	lobby_ui.visible = true
	main_ui.visible = false
	caracter_selector_ui.visible = false

func _lobby_joined(_lobby_id):
	_change_ui("LobbyUI", "CharacterSelectorUI")

func _change_ui(old_ui : String, new_ui : String):
	anim_close.play(str("Close_", old_ui))
	anim_open.play(str("Open_", new_ui))
