extends Control

@export var anim_close : AnimationPlayer
@export var anim_open : AnimationPlayer

@export var lobby_ui : Panel
@export var game_ui : MarginContainer
@export var caracter_selector_ui : Panel

func _ready():
	#Signals.host_created.connect()
	Signals.lobby_joined.connect(func(lobbby_id): _change_ui("LobbyUI", "CharacterSelectorUI"))
	Signals.lobby_start_game.connect(func():_change_ui("CharacterSelectorUI", "MainUI"))
	
	lobby_ui.visible = false
	game_ui.visible = false
	caracter_selector_ui.visible = false
	
	anim_open.play("Open_LobbyUI")

func _change_ui(old_ui : String, new_ui : String):
	anim_close.play(str("Close_", old_ui))
	anim_open.play(str("Open_", new_ui))
