extends Control

@onready var background = $"../Background"
@onready var win_ui = $VBoxContainer
@onready var timer_text = $"../StartTimer/Timer_text"

const WIN_BACKGROUND = preload("res://Recourses/UI/WinBackground.tres")

func _ready():
	GlobalScript.winner.connect(won)
	GlobalScript.reset.connect(reset)
	
	reset()

func won(player_name):
	background.texture = WIN_BACKGROUND
	
	await get_tree().create_timer(1).timeout
	
	move_to_front()
	win_ui.visible = true
	$VBoxContainer/Winner.text = str(player_name, " Won!")

func reset():
	background.texture = null
	win_ui.visible = false


func _on_again_pressed():
	GlobalScript.reset.emit()
	get_tree().paused = false
	await get_tree().create_timer(0.5).timeout
