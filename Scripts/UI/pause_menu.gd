extends Control

const PAUSE_BACKGROUND = preload("res://Recourses/UI/PauseBackground.tres")

var won = false

@onready var unpause = $MarginContainer/Main/Unpause

@onready var main = $MarginContainer/Main
@onready var settings = $MarginContainer/Settings
@onready var remap_menu = $MarginContainer/RemapMenu
@onready var margin_container = $MarginContainer

@onready var background = $"../Background"


func _ready():
	GlobalScript.winner.connect(winner)
	GlobalScript.paused.connect(change)
	
	for i in margin_container.get_children():
		i.visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
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
	$MarginContainer/Settings/Menu1.grab_focus()


func _on_remap_pressed():
	settings.visible = false
	remap_menu.visible = true
	$MarginContainer/RemapMenu/HBoxContainer/Button_container.get_child(0).grab_focus()


func _on_remap_back_pressed():
	settings.visible = true
	remap_menu.visible = false
	$MarginContainer/Settings/Menu1.grab_focus()
