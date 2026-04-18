extends Control

const PAUSE_BACKGROUND = preload("res://Recourses/UI/PauseBackground.tres")

var won = false

@onready var unpause = $Main/Unpause

@onready var main = $Main
@onready var settings = $Settings

@onready var background = $"../Background"


func _ready():
	GlobalScript.winner.connect(winner)
	GlobalScript.paused.connect(change)
	
	for i in get_child_count():
		get_child(i).visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("Pause") and settings.visible == false:
		GlobalScript.paused.emit()
		unpause.grab_focus()

func change():
	if settings.visible == true:
		settings.visible = false
	
	if background.texture == null:
		background.texture = PAUSE_BACKGROUND
	else:
		background.texture = null
	
	main.visible = not main.visible

func _on_unpause_pressed():
	GlobalScript.paused.emit()

func winner(names):
	won = true

func _on_menu_1_pressed():
	main.visible = not main.visible
	settings.visible = not settings.visible
	background.texture = null
