extends Control

@onready var background = $"../Background"
@onready var win_ui = $MarginContainer/VBoxContainer
@onready var again = $MarginContainer/VBoxContainer/Again

const WIN_BACKGROUND = preload("res://Recourses/UI/WinBackground.tres")

func _ready():
	GlobalScript.winner.connect(won)
	
	reset()

func won(player_name):
	background.texture = WIN_BACKGROUND
	background.visible = true
	
	await get_tree().create_timer(1).timeout
	
	GlobalScript.paused.emit()
	again.grab_focus()
	
	move_to_front()
	win_ui.visible = true
	$MarginContainer/VBoxContainer/Winner.text = str(player_name, " Won!")

func reset():
	background.texture = null
	win_ui.visible = false


func _on_again_pressed():
	GlobalScript.reset.emit()
	get_tree().paused = false
	await get_tree().create_timer(0.5).timeout
