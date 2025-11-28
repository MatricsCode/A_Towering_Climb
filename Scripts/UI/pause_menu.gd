extends Control

var won = false

@onready var main = $Main
@onready var settings = $Settings

@onready var background = $"../Background"


func _ready():
	GlobalScript.winner.connect(winner)
	GlobalScript.paused.connect(change)
	GlobalScript.reset.connect(reset)
	
	for i in get_child_count():
		get_child(i).visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause") and settings.visible == false:
		GlobalScript.paused.emit()

func change():
	if settings.visible == true:
		settings.visible = false
	main.visible = not main.visible
	

func _on_unpause_pressed():
	GlobalScript.paused.emit()

func winner(name):
	won = true

func reset():
	won = false

func _on_menu_1_pressed():
	main.visible = not main.visible
	settings.visible = not settings.visible
