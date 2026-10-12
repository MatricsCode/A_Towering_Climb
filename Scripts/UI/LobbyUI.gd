extends MarginContainer

@export var host_button : HoverButton
@export var join_button : HoverButton
@export var quit_button : HoverButton

# Called when the node enters the scene tree for the first time.
func _ready():
	host_button.pressed.connect(_host_pressed)
	join_button.pressed.connect(_join_pressed)
	quit_button.pressed.connect(_quit_pressed)

func _host_pressed():
	Networking._host_lobby()
func _join_pressed():
	pass
func _quit_pressed():
	get_tree().quit()
