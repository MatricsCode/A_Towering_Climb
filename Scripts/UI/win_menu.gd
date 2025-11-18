extends Control

func _ready():
	GlobalScript.winner.connect(won)
	GlobalScript.reset.connect(reset)

func won(name):
	visible = true
	$VBoxContainer/Winner.text = str(name, " Won!")

func reset():
	visible = false

func _on_again_pressed():
	GlobalScript.reset.emit()
	get_tree().paused = false
	await get_tree().create_timer(0.5).timeout
