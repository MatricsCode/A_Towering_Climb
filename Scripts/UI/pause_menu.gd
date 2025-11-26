extends Control

var won = false

func _ready():
	GlobalScript.winner.connect(winner)
	GlobalScript.paused.connect(change)
	GlobalScript.reset.connect(reset)

func change():
	visible = not visible

func _on_back_pressed():
	GlobalScript.paused.emit()

func winner(name):
	won = true

func reset():
	won = false
