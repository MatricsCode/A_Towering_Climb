extends Control

const PAUSE_BACKGROUND = preload("res://Old/Recourses/UI/PauseBackground.tres")

var won = false

@onready var unpause = $MarginContainer/Main/Unpause

@onready var main = $MarginContainer/Main
@onready var settings = $MarginContainer/Settings
@onready var remap_menu = $MarginContainer/RemapMenu
@onready var margin_container = $MarginContainer

@onready var background = $"../Background"

var paused = false

func _ready():
	Signals.winner.connect(winner)
	Signals.paused.connect(change)
	
	for i in margin_container.get_children():
		i.visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("Pause") and paused == false:
		Signals.paused.emit()
		main.visible = true
		unpause.grab_focus()
		paused = true
		
	elif Input.is_action_just_pressed("Pause") and paused == true:
		Signals.paused.emit()
		main.visible = false
		unpause.grab_focus()
		paused = false
	
	if paused == false:
		main.visible = false
		settings.visible = false
		remap_menu.visible = false
		background.texture = null
	
	elif paused == true:
		background.texture = PAUSE_BACKGROUND

func _on_unpause_pressed():
	Signals.paused.emit()

func winner(names):
	won = true

func change():
	if paused == true:
		paused = false
	else:
		paused = true

func _on_back_pressed():
	main.visible = true
	settings.visible = false
	remap_menu.visible = false
func _on_settings_pressed():
	main.visible = false
	settings.visible = true
	remap_menu.visible = false
func _on_remap_pressed():
	main.visible = false
	settings.visible = false
	remap_menu.visible = true
