extends Control

var won = false

func _ready():
	GlobalScript.winner.connect(winner)
	GlobalScript.reset.connect(reset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().paused == true and won == false:
		visible = true
	else:
		visible = false


func _on_back_pressed():
	get_tree().paused = false

func winner(name):
	won = true

func reset():
	won = false
